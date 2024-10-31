import SwiftUI
import SwiftData
import LinkKit
import KeychainSwift

class PlaidService: ObservableObject {
    @Published var didCompletePlaidSetup = false
    @Published var linkToken: String?
    @Published var isLoading = false
    @Published var error: Error?
    @Published private(set) var isPresenting = false

    private let modelContext: ModelContext
    private let accessTokenKey = "plaidAccessToken"
    private let clientId = "67203df777ab97001a6a60b3"
    private let secret = "27190c4828dc5ab7e6b91607da8998"
    var handler: Handler?
    private let keychain = KeychainSwift()

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    var hasValidPlaidConnection: Bool {
        // Check if we have a valid access token in the keychain
        if let accessToken = getStoredAccessToken() {
            return !accessToken.isEmpty
        }
        return false
    }
    
    func getStoredAccessToken() -> String? {
        let token = keychain.get(accessTokenKey)
        if let token = token {
            // Validate that it's not a public token
            guard !token.starts(with: "public-") else {
                print("⚠️ Found public token instead of access token, removing...")
                keychain.delete(accessTokenKey)
                return nil
            }
            print("🔑 PlaidService: Using access token: \(token)")
            return token
        }
        return nil
    }
    
    func fetchProvider(startDate: Date? = nil, endDate: Date? = nil) async throws -> Provider {
        guard let accessToken = getStoredAccessToken() else {
            print("❌ PlaidService: No access token found")
            throw PlaidError.noPlaidConnection
        }
                
        let url = URL(string: "https://\(PlaidEnvironment.current).plaid.com/transactions/get")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let effectiveStartDate = startDate ?? Calendar.current.date(byAdding: .day, value: -30, to: Date())!
        let effectiveEndDate = endDate ?? Date()
        
        let body: [String: Any] = [
            "client_id": clientId,
            "secret": secret,
            "access_token": accessToken,
            "start_date": DateFormatter.plaidDate.string(from: effectiveStartDate),
            "end_date": DateFormatter.plaidDate.string(from: effectiveEndDate)
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        print("📡 PlaidService: Making API request...")
        let (data, response) = try await URLSession.shared.data(for: request)
        
        #if DEBUG
        // Save response to JSON file
        if let responseString = String(data: data, encoding: .utf8) {
            Task {
                await APIResponseLogger.shared.saveResponse(responseString, prefix: "plaid_transactions")
            }
        }
        #endif
        if let httpResponse = response as? HTTPURLResponse {
            #if DEBUG
            if httpResponse.statusCode != 200 {
                if let responseString = String(data: data, encoding: .utf8) {
                    print("⚠️ API Error Response: \(responseString)")
                }
            }
            #endif
        }
        
        let provider = try createPlaidDecoder().decode(Provider.self, from: data)
        let descriptor = FetchDescriptor<Provider>()
        let existingProviders = try modelContext.fetch(descriptor)
        
        if let existingProvider = existingProviders.first(where: { $0.id == provider.id }) {
            print("📦 Returning existing provider")
            return existingProvider
        } else {
            print("📦 Creating first provider")
            modelContext.insert(provider)
            try modelContext.save()
            return provider
        }
    }
    
    func setupPlaidLink() {
        isLoading = true  // Set loading state when starting
        Task {
            do {
                print("Setting up Plaid Link")
                let token = try await createLinkToken()
                await MainActor.run {
                    createHandler(token: token)
                }
                
                try await MainActor.run {
                    guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                          let rootVC = scene.windows.first?.rootViewController else {
                        throw PlaidError.presentationError
                    }
                    presentPlaidLink(from: rootVC)
                }
            } catch {
                print("Plaid setup error: \(error)")
                await MainActor.run {
                    self.error = error
                    self.isLoading = false  // Reset loading state on error
                }
            }
        }
    }
    
    private func createLinkToken() async throws -> String {
        let url = URL(string: "https://sandbox.plaid.com/link/token/create")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "client_id": clientId,
            "secret": secret,
            "client_name": "Wonderwallet",
            "language": "en",
            "country_codes": ["US"],
            "user": [
                "client_user_id": UUID().uuidString
            ],
            "products": ["transactions"]
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(PlaidService.LinkTokenResponse.self, from: data)
        return response.linkToken
    }
    
    private func createHandler(token: String) {
        print("Creating handler with token")
        let linkConfiguration = LinkTokenConfiguration(
            token: token
        ) { [weak self] success in
            print("🔗 PLAID LINK SUCCESS")
            guard let self = self else { return }
            
            Task { @MainActor in
                do {
                    print("🔄 Starting token exchange")
                    // Exchange the public token for an access token
                    let accessToken = try await self.exchangePublicToken(success.publicToken)
                    print("✅ Token exchange complete")
                    
                    // Store the access token in Keychain
                    self.keychain.set(accessToken, forKey: self.accessTokenKey)
                    print("✅ Access token stored in Keychain")
                    
                    self.didCompletePlaidSetup = true
                    self.isPresenting = false
                    self.isLoading = false  // Reset loading state on success
                } catch {
                    print("❌ Error in Plaid setup: \(error)")
                    self.error = error
                    self.isLoading = false  // Reset loading state on error
                }
            }
        }
        
        let result = Plaid.create(linkConfiguration)
        switch result {
        case .success(let handler):
            print("✅ Handler created successfully")
            self.handler = handler
        case .failure(let error):
            print("❌ Error creating handler: \(error)")
            self.error = error
        }
    }
    
    private func exchangePublicToken(_ publicToken: String) async throws -> String {
        let url = URL(string: "https://sandbox.plaid.com/item/public_token/exchange")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "client_id": clientId,
            "secret": secret,
            "public_token": publicToken
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(ExchangeTokenResponse.self, from: data)
        
        // Store the access token
        keychain.set(response.accessToken, forKey: accessTokenKey)
        print("✅ Access token stored successfully")
        return response.accessToken
    }
    
    func presentPlaidLink(from viewController: UIViewController) {
        print("Attempting to present Plaid Link")
        guard let handler = handler, !isPresenting else {
            print("Cannot present: \(handler == nil ? "no handler" : "already presenting")")
            return
        }
        
        isPresenting = true
        let method = PresentationMethod.viewController(viewController)
        
        DispatchQueue.main.async {
            handler.open(presentUsing: method)
            print("Plaid presentation initiated")
        }
    }
}

extension PlaidService {

    enum PlaidEnvironment {
        static var current: String = "sandbox"  // or whatever default you want
    }

    struct LinkTokenResponse: Codable {
        let linkToken: String

        private enum CodingKeys: String, CodingKey {
            case linkToken
        }
    }

    private struct ExchangeTokenResponse: Codable {
        let accessToken: String
        let itemId: String
        
        private enum CodingKeys: String, CodingKey {
            case accessToken
            case itemId
        }
    }
    
    enum PlaidError: Error {
        case invalidURL
        case networkError(String)
        case noPlaidConnection
        case serverError(Int)
        case decodingError
        case presentationError
    }

    private func createPlaidDecoder() -> JSONDecoder {
        let decoder = JSONDecoder.snakeCase
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)

            if let date = DateFormatter.plaidDate.date(from: dateString) {
                return date
            }
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Date string does not match expected format"
            )
        }
        return decoder
    }
    
    func decodeTransactions(_ data: Data) throws -> [Transaction] {
        let decoder = createPlaidDecoder()
        let provider = try decoder.decode(Provider.self, from: data)
        return provider.transactions
    }
}

