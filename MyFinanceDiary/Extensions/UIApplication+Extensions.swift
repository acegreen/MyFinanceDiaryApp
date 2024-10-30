import UIKit

extension UIApplication {
    func rootViewController() -> UIViewController {
        guard let windowScene = connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController
        else {
            return UIViewController()
        }
        return rootViewController
    }
} 
