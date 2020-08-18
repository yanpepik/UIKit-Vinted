// http://ui.vinted.net/components/button.html

private let ButtonRoundedRadius = RadiusSize.default.value(size: .zero)

fileprivate extension VintedTheme {
    var buttonColor: UIColor {
        switch self {
        case .none:
            return VintedTheme.primary.buttonColor
        default:
            return primaryColor
        }
    }
    
    var emptyTapLayerBackgroundColor: CGColor {
        return buttonColor.withAlphaComponent(ClickedDarknessUnit).cgColor
    }
    
    var filledTapLayerBackgroundColor: CGColor {
        return Color(.grayscale1).withAlphaComponent(ClickedDarknessUnit).cgColor
    }
}

@objc
public enum ButtonIconPosition: Int {
    case left
    case right
}

@objc
public enum ButtonStyle: Int {
    case `default`
    case filled
    case flat
}

@objc
public enum ButtonSize: Int {
    case `default`
    case medium
    case small

    public var buttonHeight: CGFloat {
        switch self {
        case .default:
            return 11.units
        case .medium:
            return 9.units
        case .small:
            return 7.units
        }
    }
    
    public var icon: IconSize {
        switch self {
        case .default:
            return .regular
        case .medium:
            return .small
        case .small:
            return .xSmall
        }
    }
    
    public var spacingBetweenImageAndTitle: CGFloat {
        switch self {
        case .default:
            return 1.5.units
        case .medium:
            return 1.units
        case .small:
            return 0.5.units
        }
    }

    public var contentInsets: UIEdgeInsets {
        switch self {
        case .default:
            return UIEdgeInsets(top: 0.units, left: 3.5.units, bottom: 0.units, right: 3.5.units)
        case .medium:
            return UIEdgeInsets(top: 0.units, left: 2.75.units, bottom: 0.units, right: 2.75.units)
        case .small:
            return UIEdgeInsets(top: 0.units, left: 2.units, bottom: 0.units, right: 2.units)
        }
    }

    fileprivate var textType: VintedTextType {
        switch self {
        case .default:
            return .title
        case .medium:
            return .subtitle
        case .small:
            return .caption
        }
    }
    
    fileprivate var contentInsetsForOnlyImage: UIEdgeInsets {
        return UIEdgeInsets(
            top: 0,
            left: (buttonHeight - icon.size.height) / 2,
            bottom: 0,
            right: (buttonHeight - icon.size.height) / 2
        )
    }
}

public class ButtonView: UIButton {
    private var style: ButtonStyle = .filled
    private var buttonSize: ButtonSize = .default
    private var theme: VintedTheme = .none
    private var inversed = false
    private var expanded = false
    private var customStyle: ButtonCustomStyle?
    private var onTap: ButtonTap?
    private var icon: UIImage?
    private var iconPosition: ButtonIconPosition = .left
    private var isLoading = false
    
    private let tapLayer = CALayer()
    private var tapLayerColor: CGColor?
    private var loaderView: LoaderView?
    
    override public var isEnabled: Bool {
        didSet {
            updateAlpha()
        }
    }

    override public var intrinsicContentSize: CGSize {
        let contentSize: CGSize = expanded ? UIView.layoutFittingExpandedSize : super.intrinsicContentSize
        return CGSize(width: contentSize.width, height: buttonSize.buttonHeight)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        if iconPresent() && titlePresent() {
            setupImageAndTitleInsets()
        }
        loaderView?.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
    }
    
    // MARK: - Initializers
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        adjustsImageWhenHighlighted = false
        showsTouchWhenHighlighted = false
        layer.cornerRadius = ButtonRoundedRadius
        layer.masksToBounds = true
        layer.borderWidth = BorderWidth
        updateAppearance(text: nil)
        addTarget(self, action: #selector(tap), for: .touchDown)
        addTarget(self, action: #selector(tapEnd), for: .touchUpInside)
        addTarget(self, action: #selector(tapCancel), for: .touchCancel)
        addTarget(self, action: #selector(tapCancel), for: .touchUpOutside)
    }
    
    public override func setTitle(_ title: String?, for state: UIControl.State) {
        setAttributedTitle(attributedTitle(forTitle: title), for: state)
    }
    
    // MARK: - Setup
    
    @objc
    public func setup(dto: Button) {
        style = dto.style
        buttonSize = dto.size
        theme = dto.theme
        isEnabled = dto.isEnabled
        onTap = dto.onTap
        customStyle = dto.customStyle
        icon = dto.icon
        iconPosition = dto.iconPosition
        expanded = dto.expanded
        inversed = dto.inversed
        isLoading = dto.isLoading
        updateAppearance(text: dto.title)
        accessibilityIdentifier = dto.accessibilityIdentifier
        
        if let icon = icon, !buttonSize.icon.size.equalTo(icon.size) {
            assertionFailure("Expected icon size to be \(buttonSize.icon.size) got \(icon.size)")
        }
    }
    
    // MARK: - Appearance
    
    private func updateAppearance(text: String?) {
        if let customStyle = customStyle {
            setupCustomStyle(customStyle: customStyle)
        } else {
            switch style {
            case .default:
                setupDefaultAppearance()
            case .filled:
                setupFilledAppearance()
            case .flat:
                setupFlatAppearance()
            }
        }

        setAttributedTitle(attributedTitle(forTitle: text), for: state)
        setImage(icon, for: state)
        setupContentEdgeInsets()
        imageView?.contentMode = .scaleAspectFill
        if isLoading {
            displayLoader()
        } else {
            hideLoader()
        }
    }
    
    private func setupCustomStyle(customStyle: ButtonCustomStyle) {
        tapLayerColor = customStyle.tapLayerColor
        layer.borderColor = customStyle.borderColor
        layer.borderWidth = customStyle.borderWidth
        backgroundColor = customStyle.backgroundColor
    }
    
    private func setupDefaultAppearance() {
        tapLayerColor = theme.emptyTapLayerBackgroundColor
        layer.borderColor = inversed ? Color(.grayscale9).cgColor : theme.buttonColor.cgColor
        layer.borderWidth = 1
        backgroundColor = UIColor.clear
    }
    
    private func setupFilledAppearance() {
        tapLayerColor = theme.filledTapLayerBackgroundColor
        layer.borderWidth = 0
        backgroundColor = inversed ? Color(.grayscale9) : theme.buttonColor
    }
    
    private func setupFlatAppearance() {
        tapLayerColor = theme.emptyTapLayerBackgroundColor
        layer.borderWidth = 0
        backgroundColor = UIColor.clear
    }
    
    private func updateAlpha() {
        alpha = isEnabled ? AlphaEnabled : AlphaDisabled
    }
    
    private func attributedTitle(forTitle title: String?) -> NSAttributedString? {
        let theme = self.theme == .none ? VintedTheme.primary : self.theme
        let inversed = (style == .filled && !self.inversed) || (style != .filled && self.inversed)
        let attributedTitle = attributedText(
            string: title,
            type: buttonSize.textType,
            inversed: inversed,
            theme: theme,
            lineBreakMode: .byTruncatingTail
        )
        return attributedTitle
    }

    // MARK: - Sizes

    private func setupContentEdgeInsets() {
        let onlyIconPresent = !titlePresent() && iconPresent()
        let contentInsets = buttonSize.contentInsets

        if onlyIconPresent {
            titleEdgeInsets = UIEdgeInsets.zero
            imageEdgeInsets = UIEdgeInsets.zero
            contentEdgeInsets = buttonSize.contentInsetsForOnlyImage
        } else if iconPresent() && titlePresent() {
            let spacing = buttonSize.spacingBetweenImageAndTitle / 2
            setupImageAndTitleInsets()
            contentEdgeInsets = UIEdgeInsets(
                top: contentInsets.top,
                left: contentInsets.left + spacing,
                bottom: contentInsets.bottom,
                right: contentInsets.right + spacing
            )
        } else {
            imageEdgeInsets = UIEdgeInsets.zero
            titleEdgeInsets = UIEdgeInsets.zero
            contentEdgeInsets = contentInsets
        }
    }

    private func setupImageAndTitleInsets() {
        guard titleLabel != nil, imageView != nil else {
            return
        }
        let spacing = buttonSize.spacingBetweenImageAndTitle / 2
        if isLoading {
            imageEdgeInsets = .zero
            titleEdgeInsets = .zero
        } else if iconPosition == .right {
            semanticContentAttribute = .forceRightToLeft
            imageEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: -spacing)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -spacing, bottom: 0, right: spacing)
        } else {
            semanticContentAttribute = .unspecified
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -spacing, bottom: 0, right: spacing)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: -spacing)
        }
    }

    private func titlePresent() -> Bool {
        let title = currentAttributedTitle?.string
        return title != nil && title?.isEmpty == false
    }

    private func iconPresent() -> Bool {
        return icon != nil
    }

    // MARK: - Actions
    
    @objc
    private func tap() {
        guard onTap != nil else {
            return
        }

        tapLayer.backgroundColor = tapLayerColor
        tapLayer.cornerRadius = ButtonRoundedRadius
        tapLayer.frame = CGRect(origin: CGPoint(), size: frame.size)
        layer.addSublayer(tapLayer)
    }
    
    @objc
    private func tapEnd() {
        guard let onTap = onTap else {
            return
        }

        removeTapLayer()
        onTap(self)
    }
    
    @objc
    private func tapCancel() {
        removeTapLayer()
    }
    
    private func removeTapLayer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + ClickedRemovalDelay) { [weak self] in
            self?.tapLayer.removeFromSuperlayer()
        }
    }

    private func loaderSize(for size: ButtonSize) -> LoaderSize {
        switch size {
        case .default: return .default
        case .small: return .small
        case .medium: return .medium
        }
    }

    private func displayLoader() {
        guard self.loaderView == nil else { return }
        let loaderView = Loader(
            state: .loading,
            size: loaderSize(for: buttonSize),
            theme: style == .filled ? nil : theme
        ).createView()
        loaderView.frame = CGRect(origin: .zero, size: loaderView.intrinsicContentSize)
        loaderView.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        loaderView.isUserInteractionEnabled = false
        addSubview(loaderView)
        self.loaderView = loaderView as? LoaderView
        titleLabel?.layer.opacity = 0
        imageView?.layer.transform = CATransform3DMakeScale(0.0, 0.0, 0.0) // hack to hide uibutton's imageview
    }

    private func hideLoader() {
        loaderView?.removeFromSuperview()
        loaderView = nil
        titleLabel?.layer.opacity = 1
        imageView?.layer.transform = CATransform3DIdentity // hack to unhide uibutton's imageview
    }
}

// MARK: - IBInspectable

extension ButtonView {
    @IBInspectable var styleInt: Int {
        get {
            return style.rawValue
        }
        set {
            style = ButtonStyle(rawValue: newValue) ?? .filled
            updateAppearance(text: titleLabel?.attributedText?.string)
        }
    }
    
    @IBInspectable var sizeInt: Int {
        get {
            return buttonSize.rawValue
        }
        set {
            buttonSize = ButtonSize(rawValue: newValue) ?? .default
            updateAppearance(text: titleLabel?.attributedText?.string)
        }
    }
  
    @IBInspectable var themeInt: Int {
        get {
            return theme.rawValue
        }
        set {
            theme = VintedTheme(rawValue: newValue) ?? .none
            updateAppearance(text: titleLabel?.attributedText?.string)
        }
    }
}
