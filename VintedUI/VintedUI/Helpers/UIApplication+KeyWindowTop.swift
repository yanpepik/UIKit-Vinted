public extension UIApplication {

    var keyWindowTopViewController: UIViewController? {
        windows.first(where: \.isKeyWindow)?.rootViewController?.topMostViewController
    }
}
