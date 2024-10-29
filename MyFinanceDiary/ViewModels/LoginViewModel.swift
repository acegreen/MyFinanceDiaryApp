import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String = ""
    @Published var isShowingError: Bool = false
    
    func clearFields() {
        username = ""
        password = ""
        errorMessage = ""
        isShowingError = false
    }
    
    func validateInput() -> Bool {
        if username.isEmpty || password.isEmpty {
            errorMessage = "Please fill in all fields"
            isShowingError = true
            return false
        }
        return true
    }
    
    func handleError(_ error: Error) {
        errorMessage = error.localizedDescription
        isShowingError = true
    }
} 