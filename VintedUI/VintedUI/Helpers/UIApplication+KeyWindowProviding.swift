extension UIApplication: KeyWindowProviding {
    public var window: UIWindow? {
        VintedUI.ConfigurationManager.shared.configuration.windowProvider.window
    }

    public var safeAreaInsets: UIEdgeInsets {
        VintedUI.ConfigurationManager.shared.configuration.windowProvider.safeAreaInsets
    }
}
