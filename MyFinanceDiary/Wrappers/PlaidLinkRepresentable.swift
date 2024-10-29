import SwiftUI
import UIKit

struct PlaidLinkRepresentable: UIViewControllerRepresentable {
    let plaidService: PlaidService
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        plaidService.presentPlaidLink(from: viewController)
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
} 