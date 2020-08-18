public typealias ButtonTap = (_ button: ButtonView) -> ()

enum ButtonCustomStyle {
    case facebook
    case google
    case horizontalFilter
    
    var backgroundColor: UIColor {
        switch self {
        case .facebook:
            return FacebookColor
        case .google:
            return GoogleColor
        case .horizontalFilter:
            return Color(.grayscale9)
        }
    }
   
    var tapLayerColor: CGColor {
        return UIColor.clear.cgColor
    }
    
    var borderColor: CGColor {
        switch self {
        case .facebook, .google:
            return backgroundColor.cgColor
        case .horizontalFilter:
            return Color(.grayscale7).cgColor
        }
    }
    
    var borderWidth: CGFloat {
        return 1
    }
}

public class Button: NSObject {
    let title: String?
    let theme: VintedTheme
    let size: ButtonSize
    let style: ButtonStyle
    let expanded: Bool
    let isEnabled: Bool
    let isLoading: Bool
    let inversed: Bool
    let icon: UIImage?
    let iconPosition: ButtonIconPosition
    let customStyle: ButtonCustomStyle?
    let accessibilityIdentifier: String
    let onTap: ButtonTap?

    public class func horizontalFiltersButton(title: String,
                                              icon: UIImage?,
                                              selected: Bool,
                                              accessibilityIdentifier: String,
                                              onTap: ButtonTap?) -> Button {
        return Button(
            title: title,
            theme: selected ? .primary : .amplified,
            size: .medium,
            style: selected ? .filled : .default,
            expanded: false,
            isEnabled: true,
            isLoading: false,
            inversed: false,
            icon: icon,
            iconPosition: .left,
            customStyle: selected ? nil : .horizontalFilter,
            accessibilityIdentifier: accessibilityIdentifier,
            onTap: onTap
        )
    }
    
    public class func facebookButton(title: String?, size: ButtonSize, onTap: ButtonTap?) -> Button {
        return Button(
            title: title,
            theme: .none,
            size: size,
            style: .filled,
            expanded: false,
            isEnabled: true,
            isLoading: false,
            inversed: false,
            icon: nil,
            iconPosition: .left,
            customStyle: .facebook,
            accessibilityIdentifier: "facebook",
            onTap: onTap
        )
    }
    
    public class func googleButton(title: String?, size: ButtonSize, onTap: ButtonTap?) -> Button {
        return Button(
            title: title,
            theme: .none,
            size: size,
            style: .filled,
            expanded: false,
            isEnabled: true,
            isLoading: false,
            inversed: false,
            icon: nil,
            iconPosition: .left,
            customStyle: .google,
            accessibilityIdentifier: "google",
            onTap: onTap
        )
    }
    
    // Internal init, should not be exposed
    init(title: String?,
         theme: VintedTheme,
         size: ButtonSize,
         style: ButtonStyle,
         expanded: Bool,
         isEnabled: Bool,
         isLoading: Bool,
         inversed: Bool,
         icon: UIImage?,
         iconPosition: ButtonIconPosition,
         customStyle: ButtonCustomStyle?,
         accessibilityIdentifier: String,
         onTap: ButtonTap? = nil) {
        self.title = title
        self.theme = theme
        self.size = size
        self.style = style
        self.expanded = expanded
        self.isEnabled = isEnabled
        self.isLoading = isLoading
        self.inversed = inversed
        self.icon = icon
        self.iconPosition = iconPosition
        self.customStyle = customStyle
        self.onTap = onTap
        self.accessibilityIdentifier = accessibilityIdentifier
        super.init()
    }
    
    @objc
    public convenience init(
        title: String?,
        theme: VintedTheme = .none,
        size: ButtonSize = .default,
        style: ButtonStyle = .default,
        expanded: Bool = false,
        isEnabled: Bool = true,
        isLoading: Bool = false,
        inversed: Bool = false,
        icon: UIImage? = nil,
        iconPosition: ButtonIconPosition = .left,
        accessibilityIdentifier: String,
        onTap: ButtonTap? = nil) {
        self.init(
            title: title,
            theme: theme,
            size: size,
            style: style,
            expanded: expanded,
            isEnabled: isEnabled,
            isLoading: isLoading,
            inversed: inversed,
            icon: icon,
            iconPosition: iconPosition,
            customStyle: nil,
            accessibilityIdentifier: accessibilityIdentifier,
            onTap: onTap
        )
    }
    
    public convenience init(
        title: String?,
        theme: VintedTheme = .none,
        size: ButtonSize = .default,
        style: ButtonStyle = .default,
        expanded: Bool = false,
        isEnabled: Bool = true,
        isLoading: Bool = false,
        inversed: Bool = false,
        icon: UIImage? = nil,
        iconPosition: ButtonIconPosition = .left,
        accessibilityIdentifier: String,
        onTap: @escaping () -> ()) {
        self.init(
            title: title,
            theme: theme,
            size: size,
            style: style,
            expanded: expanded,
            isEnabled: isEnabled,
            isLoading: isLoading,
            inversed: inversed,
            icon: icon,
            iconPosition: iconPosition,
            customStyle: nil,
            accessibilityIdentifier: accessibilityIdentifier,
            onTap: { _ in onTap() }
        )
    }
}

extension Button: ViewData {
    public func createView() -> UIView {
        let view = ButtonView()
        view.setup(dto: self)
        return view
    }

    public func canReuse(view: UIView) -> Bool {
        return view is ButtonView
    }

    public func setupView(view: UIView) {
        guard let view = view as? ButtonView else {
            return
        }
        view.setup(dto: self)
    }
}

// MARK: - Obj-c helpers

extension Button {
    @available(swift, obsoleted: 3.0)
    @objc
    public convenience init(title: String?,
                            theme: VintedTheme,
                            size: ButtonSize,
                            style: ButtonStyle,
                            accessibilityIdentifier: String,
                            onTap: ButtonTap?) {
        self.init(
            title: title,
            theme: theme,
            size: size,
            style: style,
            expanded: false,
            isEnabled: true,
            icon: nil,
            iconPosition: .left,
            accessibilityIdentifier: accessibilityIdentifier,
            onTap: onTap
        )
    }
    
    @available(swift, obsoleted: 3.0)
    @objc
    public convenience init(title: String?,
                            theme: VintedTheme,
                            size: ButtonSize,
                            style: ButtonStyle,
                            isEnabled: Bool,
                            accessibilityIdentifier: String,
                            onTap: ButtonTap?) {
        self.init(
            title: title,
            theme: theme,
            size: size,
            style: style,
            expanded: false,
            isEnabled: isEnabled,
            isLoading: false,
            inversed: false,
            icon: nil,
            iconPosition: .left,
            customStyle: nil,
            accessibilityIdentifier: accessibilityIdentifier,
            onTap: onTap
        )
    }
}
