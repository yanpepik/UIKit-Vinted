public extension UIApplication {

    static var safeAreaInsets: UIEdgeInsets {
        VintedUI.ConfigurationManager.shared.configuration.windowProvider.safeAreaInsets
    }
}
