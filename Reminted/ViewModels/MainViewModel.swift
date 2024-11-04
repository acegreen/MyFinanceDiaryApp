import Foundation

@MainActor
class MainViewModel: ObservableObject {
    @Published var provider: Provider?
    @Published var isLoading: Bool = false
    @Published var error: Error?
    var plaidService: PlaidService

    init(plaidService: PlaidService) {
        self.plaidService = plaidService
    }

    func fetchProvider() async throws {
        provider = try await plaidService.fetchProvider()
    }
}
