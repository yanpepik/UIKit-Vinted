@objcMembers
public final class NavigationBarAppearance: NSObject {
    private let buttonItemAppearance = NavBarButtonItemAppearance()
    public let backgroundColor = Color(.grayscale9)
    public let tintColor = Color(.grayscale1)
    public let titleTextAttributes = VintedUI.textAttributes(type: .title, lineBreakMode: .byTruncatingTail)
    public let isTranslucent = true
    public let barStyle: UIBarStyle = .default
    public var shadowImage: UIImage? {
        return UIImage(named: "headerShadow", in: Bundle(for: NavigationBarAppearance.self), compatibleWith: nil)
    }
    public var backgroundImage: UIImage? {
        UIImage.image(color: backgroundColor, size: CGSize(width: 1, height: 1))
    }
    
    @available(iOS 13.0, *)
    public var standardAppearance: UINavigationBarAppearance {
        return UINavigationBar.appearance().standardAppearance
    }
    
    public func apply() {
        let appearance = UINavigationBar.appearance()
                
        appearance.barStyle = barStyle
        appearance.barTintColor = backgroundColor
        appearance.tintColor = tintColor
        appearance.isTranslucent = isTranslucent
        appearance.titleTextAttributes = titleTextAttributes
        appearance.shadowImage = shadowImage
        appearance.backgroundColor = backgroundColor
        appearance.setBackgroundImage(backgroundImage, for: .default)
        
        if #available(iOS 13.0, *) {
            appearance.standardAppearance = navigationBarStandardAppearance(with: appearance)
            appearance.scrollEdgeAppearance = navigationBarStandardAppearance(with: appearance)
        } else {
            buttonItemAppearance.apply()
        }
        buttonItemAppearance.applyNavigationBarUIButtonAppearance()
    }
    
    @available(iOS 13.0, *)
    private func navigationBarStandardAppearance(with appearance: UINavigationBar) -> UINavigationBarAppearance {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = appearance.backgroundColor
        navigationBarAppearance.shadowImage = appearance.shadowImage
        navigationBarAppearance.backgroundImage = appearance.backgroundImage(for: .default)
        navigationBarAppearance.titleTextAttributes = appearance.titleTextAttributes ?? [:]
        navigationBarAppearance.buttonAppearance = buttonItemAppearance.appearence
        return navigationBarAppearance
    }
}
