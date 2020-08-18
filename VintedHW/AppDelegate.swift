import UIKit
import VintedAPI
import VintedUI

let ApplicationDelegate = UIApplication.shared.delegate as! AppDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow? = AppRouter.shared.window
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NavigationBarAppearance().apply()
        AppRouter.shared.routeToFeed()
        return true
    }
}

func __(_ translationKey: String) -> String {
    return translationKey
}
