@objc
public extension UIViewController {
    var topPresentedViewController: UIViewController? {
        var target: UIViewController? = self
        while target?.presentedViewController != nil {
            target = target?.presentedViewController
        }
        return target
    }

    var topVisibleViewController: UIViewController? {
        if let nav = self as? UINavigationController {
            return nav.topViewController?.topVisibleViewController
        } else if let tabBar = self as? UITabBarController {
            return tabBar.selectedViewController?.topVisibleViewController
        }
        return self
    }

    var topMostViewController: UIViewController? {
        return self.topPresentedViewController?.topVisibleViewController
    }
}
