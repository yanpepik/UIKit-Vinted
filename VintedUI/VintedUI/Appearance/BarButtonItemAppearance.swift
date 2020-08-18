protocol BarButtonItemAppearance {
    typealias TextAttributes = [NSAttributedString.Key: Any]

    var enabledTextAttibutes: TextAttributes { get }
    var disabledTextAttibutes: TextAttributes { get }
    var titlePositionAdjustment: UIOffset { get }

    func apply(for containerType: UIAppearanceContainer.Type?)
}

extension BarButtonItemAppearance {

    var enabledTextAttibutes: TextAttributes {
        return textAttributes(type: .subtitle, theme: .amplified, alpha: AlphaEnabled)
    }
    var disabledTextAttibutes: TextAttributes {
        return textAttributes(type: .subtitle, theme: .muted, alpha: AlphaDisabled)
    }
    var titlePositionAdjustment: UIOffset {
        return UIOffset(horizontal: 0, vertical: 1)
    }

    func apply(for containerType: UIAppearanceContainer.Type? = nil) {
        let appearance = barButtonAppearance(for: containerType)
        appearance.setBackgroundVerticalPositionAdjustment(titlePositionAdjustment.vertical, for: .default)
        appearance.setTitleTextAttributes(enabledTextAttibutes, for: .normal)
        appearance.setTitleTextAttributes(enabledTextAttibutes, for: .selected)
        appearance.setTitleTextAttributes(enabledTextAttibutes, for: .highlighted)
        appearance.setTitleTextAttributes(disabledTextAttibutes, for: .disabled)
    }

    private func barButtonAppearance(for containerType: UIAppearanceContainer.Type?) -> UIBarButtonItem {
        guard let containerType = containerType else { return UIBarButtonItem.appearance() }
        return UIBarButtonItem.appearance(whenContainedInInstancesOf: [containerType.self])
    }
}
