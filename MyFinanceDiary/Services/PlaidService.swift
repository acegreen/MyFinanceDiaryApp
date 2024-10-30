import SwiftUI
import LinkKit
import SwiftKeychainWrapper

class PlaidService: ObservableObject {
    @Published var didCompletePlaidSetup = false
    @Published var linkToken: String?
    @Published var isLoading = false
    @Published var error: Error?
    @Published private(set) var isPresenting = false
    
    private let accessTokenKey = "plaidAccessToken"
    private let clientId = "67203df777ab97001a6a60b3"
    private let secret = "27190c4828dc5ab7e6b91607da8998"
    var handler: Handler?

    var hasValidPlaidConnection: Bool {
        // Check if we have a valid access token in the keychain
        if let accessToken = getStoredAccessToken() {
            return !accessToken.isEmpty
        }
        return false
    }
    
    func getStoredAccessToken() -> String? {
        let token = KeychainWrapper.standard.string(forKey: accessTokenKey)
        if let token = token {
            // Validate that it's not a public token
            guard !token.starts(with: "public-") else {
                print("⚠️ Found public token instead of access token, removing...")
                KeychainWrapper.standard.removeObject(forKey: accessTokenKey)
                return nil
            }
            return token
        }
        return nil
    }
    
    func fetchTransactions(startDate: Date, endDate: Date) async throws -> [Transaction] {
        guard let accessToken = getStoredAccessToken() else {
            print("❌ No Plaid access token found")
            throw PlaidError.noPlaidConnection
        }
        
        let url = URL(string: "https://\(PlaidEnvironment.current).plaid.com/transactions/get")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "client_id": clientId,
            "secret": secret,
            "access_token": accessToken,
            "start_date": dateFormatter.string(from: startDate),
            "end_date": dateFormatter.string(from: endDate)
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        print("📡 Fetching from Plaid API...")
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
            print("📡 API Status: \(httpResponse.statusCode)")
            
            #if DEBUG
            if httpResponse.statusCode != 200 {
                if let responseString = String(data: data, encoding: .utf8) {
                    print("⚠️ API Error Response: \(responseString)")
                }
            }
            #endif
        }
        
        let plaidResponse = try JSONDecoder().decode(PlaidTransactionsResponse.self, from: data)
        return plaidResponse.transactions
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
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
                    KeychainWrapper.standard.set(accessToken, forKey: self.accessTokenKey)
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
        KeychainWrapper.standard.set(response.accessToken, forKey: accessTokenKey)
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

        enum CodingKeys: String, CodingKey {
            case linkToken = "link_token"
        }
    }

    private struct ExchangeTokenResponse: Codable {
        let accessToken: String
        let itemId: String
        
        enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case itemId = "item_id"
        }
    }
    
    private struct PlaidTransactionsResponse: Codable {
        let accounts: [Account]
        let transactions: [Transaction]
        
        enum CodingKeys: String, CodingKey {
            case accounts
            case transactions
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
}

