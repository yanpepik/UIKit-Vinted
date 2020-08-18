final class NavBarButtonItemAppearance: NSObject, BarButtonItemAppearance {
    func applyNavigationBarUIButtonAppearance() {
        let buttonAppearance = UIButton.appearance(whenContainedInInstancesOf: [UINavigationBar.self])
        buttonAppearance.showsTouchWhenHighlighted = true
    }
}

@available(iOS 13.0, *)
extension NavBarButtonItemAppearance {

    public var appearence: UIBarButtonItemAppearance {
        let buttonAppearance = UIBarButtonItemAppearance()
        buttonAppearance.normal.titleTextAttributes = enabledTextAttibutes
        buttonAppearance.normal.titlePositionAdjustment = titlePositionAdjustment
        buttonAppearance.highlighted.titleTextAttributes = enabledTextAttibutes
        buttonAppearance.disabled.titleTextAttributes = disabledTextAttibutes
        return buttonAppearance
    }
}
