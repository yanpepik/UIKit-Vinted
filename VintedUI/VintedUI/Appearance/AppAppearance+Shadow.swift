@objc
extension AppAppearance {

    public func addShadow(to viewController: UIViewController) {
        if #available(iOS 13.0, *) {
            let navigationItemAppearance = navigationBarAppearance.standardAppearance.copy()
            navigationItemAppearance.shadowImage = navigationBarAppearance.shadowImage
            viewController.navigationItem.standardAppearance = navigationItemAppearance
        } else {
            viewController.navigationController?.navigationBar.shadowImage = navigationBarAppearance.shadowImage
        }
    }

    public func removeShadow(from viewController: UIViewController) {

        if #available(iOS 13.0, *) {
            let navigationItemAppearance = navigationBarAppearance.standardAppearance.copy()
            navigationItemAppearance.shadowImage = nil
            navigationItemAppearance.shadowColor = nil
            viewController.navigationItem.standardAppearance = navigationItemAppearance
        } else {
            viewController.navigationController?.navigationBar.shadowImage = UIImage()
        }
    }
}
