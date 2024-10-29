import SwiftUI
import LinkKit
import SwiftKeychainWrapper

enum PlaidError: Error {
    case invalidURL
    case networkError(String)
    case noPlaidConnection
    case serverError(Int)
    case decodingError
    case presentationError
}

class PlaidService: ObservableObject {
    @Published var didCompletePlaidSetup = false
    @Published var linkToken: String?
    @Published var isLoading = false
    @Published var error: Error?
    
    private let accessTokenKey = "plaidAccessToken"
    private let clientId = "67203df777ab97001a6a60b3"
    private let secret = "27190c4828dc5ab7e6b91607da8998"
    var handler: Handler?
    
    // Add method to get stored access token
    func getStoredAccessToken() -> String? {
        return KeychainWrapper.standard.string(forKey: accessTokenKey)
    }
    
    // Add method to fetch transactions (mock for now)
    func fetchTransactions(startDate: Date, endDate: Date) async throws -> [Transaction] {
        guard let _ = getStoredAccessToken() else {
            throw PlaidError.noPlaidConnection
        }
        
        // For testing, return mock data
        return [] // Replace with actual implementation later
    }
    
    func setupPlaidLink() {
        Task {
            do {
                print("Setting up Plaid Link")
                let token = try await createLinkToken()
                await MainActor.run {
                    createHandler(token: token)
                }
                
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                      let rootViewController = windowScene.windows.first?.rootViewController else {
                    throw PlaidError.presentationError
                }
                
                await MainActor.run {
                    presentPlaidLink(from: rootViewController)
                }
            } catch {
                print("Plaid setup error: \(error)")
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
        let response = try JSONDecoder().decode(LinkTokenResponse.self, from: data)
        return response.linkToken
    }
    
    private func createHandler(token: String) {
        print("Creating handler with token")
        let linkConfiguration = LinkTokenConfiguration(
            token: token
        ) { [weak self] success in
            print("Plaid Link success!")
            print("Public token received: \(success.publicToken)")
            
            // Store the public token
            KeychainWrapper.standard.set(success.publicToken, forKey: self?.accessTokenKey ?? "")
            
            // Notify that setup is complete
            Task { @MainActor in
                self?.didCompletePlaidSetup = true
            }
        }
        
        let result = Plaid.create(linkConfiguration)
        switch result {
        case .success(let handler):
            print("Handler created successfully")
            self.handler = handler
        case .failure(let error):
            print("Error creating handler: \(error)")
        }
    }
    
    func presentPlaidLink(from viewController: UIViewController) {
        print("Attempting to present Plaid Link")
        guard let handler = handler else {
            print("No handler available")
            return
        }
        
        let method = PresentationMethod.viewController(viewController)
        
        DispatchQueue.main.async {
            handler.open(presentUsing: method)
            print("Plaid presentation initiated")
        }
    }
}

struct LinkTokenResponse: Codable {
    let linkToken: String
    
    enum CodingKeys: String, CodingKey {
        case linkToken = "link_token"
    }
}

