import Foundation
import VintedUI
import UIKit

final class AppRouter {
    lazy var window = UIWindow()
    static let shared = AppRouter()
    
    private init() {}
    
    private var feedViewController: UIViewController {
        NavigationController(rootViewController: UIViewController())
    }
    
    func routeToFeed() {
        window.rootViewController = feedViewController
        window.makeKeyAndVisible()
    }
}
