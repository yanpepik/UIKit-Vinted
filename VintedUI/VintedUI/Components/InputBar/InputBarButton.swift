public final class InputBarButton: NSObject {
    let button: Button
    
    @objc
    public init(title: String? = nil,
                icon: UIImage? = nil,
                theme: VintedTheme = .primary,
                isEnabled: Bool = true,
                accessibilityIdentifier: String,
                onTap: (() -> ())? = nil) {
        self.button = Button(
            title: title,
            theme: theme,
            size: .medium,
            style: .flat,
            expanded: false,
            isEnabled: isEnabled,
            icon: icon,
            iconPosition: .left,
            accessibilityIdentifier: accessibilityIdentifier,
            onTap: onTap == nil ? nil : { _ in onTap?() }
        )
        super.init()
    }
}

extension InputBarButton: ViewData {
    public func createView() -> UIView {
        return button.createView()
    }
    
    public func canReuse(view: UIView) -> Bool {
        return button.canReuse(view: view)
    }
    
    public func setupView(view: UIView) {
        button.setupView(view: view)
    }
}
