public class Cell: NSObject {
    let title: String?
    let subtitle: String?
    let titleIcon: UIImage?
    let validation: String?
    
    let body: ViewData?
    let leftSuffix: CellLeftSideSuffixable?
    let rightSuffix: CellRightSideSuffixable?
    let theme: VintedTheme
    let size: CellSize
    let highlighted: Bool
    let disabled: Bool
    let accessibilityIdentifier: String?
    let shouldHideTapLayer: Bool
    let dividers: [DividerBorder]?
    let onTap: (() -> ())?
    
    public required init(
        title: String? = nil,
        subtitle: String? = nil,
        titleIcon: UIImage? = nil,
        body: ViewData? = nil,
        leftSuffix: CellLeftSideSuffixable? = nil,
        rightSuffix: CellRightSideSuffixable? = nil,
        theme: VintedTheme = .none,
        validation: String? = nil,
        size: CellSize = .normal,
        highlighted: Bool = false,
        disabled: Bool = false,
        accessibilityIdentifier: String? = nil,
        shouldHideTapLayer: Bool = false,
        dividers: [DividerBorder]? = nil,
        onTap: (() -> ())? = nil) {
        self.title = title
        self.titleIcon = titleIcon
        self.subtitle = subtitle
        self.body = body
        self.rightSuffix = rightSuffix
        self.leftSuffix = leftSuffix
        self.theme = theme
        self.size = size
        self.highlighted = highlighted
        self.disabled = disabled
        self.accessibilityIdentifier = accessibilityIdentifier
        self.validation = validation
        self.shouldHideTapLayer = shouldHideTapLayer
        self.onTap = onTap
        self.dividers = dividers
        super.init()
    }
    
    override public var description: String {
        var descriptionLines: [String] = []
        descriptionLines.append("Title: \(title ?? "")")
        descriptionLines.append("Subtitle: \(subtitle ?? "")")
        descriptionLines.append("Validation: \(validation ?? "")")
        descriptionLines.append("body: \(body.debugDescription)")
        return descriptionLines.joined(separator: "\r\n")
    }
}

extension Cell: ViewData {
    public func createView() -> UIView {
        let view = CellView()
        view.setup(dto: self)
        return view
    }

    public func canReuse(view: UIView) -> Bool {
        return view is CellView
    }

    public func setupView(view: UIView) {
        (view as? CellView)?.setup(dto: self)
    }
}

// MARK: - Objective-c only helpers

extension Cell {
    @available(swift, obsoleted: 3.0)
    @objc
    public convenience init(
        title: String? = nil,
        subtitle: String? = nil,
        bodyText: String? = nil,
        leftSuffix: CellLeftSideSuffixable? = nil,
        rightSuffix: CellRightSideSuffixable? = nil,
        theme: VintedTheme = .none,
        size: CellSize = .normal,
        accessibilityIdentifier: String? = nil,
        onTap: (() -> ())? = nil) {
        
        let inversed = theme != .none
        var body: ViewData?
        if let bodyText = bodyText {
            body = AttributedText(text: bodyText, type: .body, theme: .none, inversed: inversed)
        }
        
        self.init(
            title: title,
            subtitle: subtitle,
            body: body,
            leftSuffix: leftSuffix,
            rightSuffix: rightSuffix,
            theme: theme,
            size: size,
            accessibilityIdentifier: accessibilityIdentifier,
            onTap: onTap
        )
    }
    
    @available(swift, obsoleted: 3.0)
    @objc
    public convenience init(
        title: String? = nil,
        subtitle: String? = nil,
        body: ViewData? = nil,
        leftSuffix: CellLeftSideSuffixable? = nil,
        rightSuffix: CellRightSideSuffixable? = nil,
        theme: VintedTheme = .none,
        size: CellSize = .normal,
        accessibilityIdentifier: String? = nil,
        onTap: (() -> ())? = nil) {
        self.init(
            title: title,
            subtitle: subtitle,
            body: body,
            leftSuffix: leftSuffix,
            rightSuffix: rightSuffix,
            theme: theme,
            size: size,
            accessibilityIdentifier: accessibilityIdentifier,
            onTap: onTap
        )
    }
    
    @available(swift, obsoleted: 3.0)
    @objc
    public convenience init(
        title: String? = nil,
        subtitle: String? = nil,
        body: ViewData? = nil,
        leftSuffix: CellLeftSideSuffixable? = nil,
        rightSuffix: CellRightSideSuffixable? = nil,
        theme: VintedTheme = .none,
        size: CellSize = .normal,
        onTap: (() -> ())? = nil) {
        self.init(
            title: title,
            subtitle: subtitle,
            body: body,
            leftSuffix: leftSuffix,
            rightSuffix: rightSuffix,
            theme: theme,
            size: size,
            onTap: onTap
        )
    }

    @available(swift, obsoleted: 3.0)
    @objc
    public convenience init(
        title: String?,
        subtitle: String?,
        titleIcon: UIImage?,
        body: ViewData?,
        leftSuffix: CellLeftSideSuffixable?,
        rightSuffix: CellRightSideSuffixable?,
        theme: VintedTheme,
        validation: String?,
        size: CellSize,
        highlighted: Bool,
        disabled: Bool,
        accessibilityIdentifier: String?,
        shouldHideTapLayer: Bool,
        onTap: (() -> ())?) {
        self.init(title: title,
                  subtitle: subtitle,
                  titleIcon: titleIcon,
                  body: body,
                  leftSuffix: leftSuffix,
                  rightSuffix: rightSuffix,
                  theme: theme,
                  validation: validation,
                  size: size,
                  highlighted: highlighted,
                  disabled: disabled,
                  accessibilityIdentifier: accessibilityIdentifier,
                  shouldHideTapLayer: shouldHideTapLayer,
                  onTap: onTap)
    }
    
    @available(swift, obsoleted: 3.0)
    @objc
    public convenience init(body: ViewData, size: CellSize) {
        self.init(
            body: body,
            theme: .none,
            size: size
        )
    }
}

extension Cell {
    public func with(
        title: String? = nil,
        subtitle: String? = nil,
        titleIcon: UIImage? = nil,
        body: ViewData? = nil,
        leftSuffix: CellLeftSideSuffixable? = nil,
        rightSuffix: CellRightSideSuffixable? = nil,
        theme: VintedTheme? = nil,
        validation: String? = nil,
        size: CellSize? = nil,
        highlighted: Bool? = nil,
        disabled: Bool? = nil,
        accessibilityIdentifier: String? = nil,
        shouldHideTapLayer: Bool? = nil,
        dividers: [DividerBorder]? = nil,
        onTap: (() -> ())? = nil) -> Cell {
        
        return Cell(title: title ?? self.title,
                    subtitle: subtitle ?? self.subtitle,
                    titleIcon: titleIcon ?? self.titleIcon,
                    body: body ?? self.body,
                    leftSuffix: leftSuffix ?? self.leftSuffix,
                    rightSuffix: rightSuffix ?? self.rightSuffix,
                    theme: theme ?? self.theme,
                    validation: validation ?? self.validation,
                    size: size ?? self.size,
                    highlighted: highlighted ?? self.highlighted,
                    disabled: disabled ?? self.disabled,
                    accessibilityIdentifier: accessibilityIdentifier ?? self.accessibilityIdentifier,
                    shouldHideTapLayer: shouldHideTapLayer ?? self.shouldHideTapLayer,
                    dividers: dividers ?? self.dividers,
                    onTap: onTap ?? self.onTap
        )
    }
}

extension ViewData {
    public func inCell(
        title: String? = nil,
        subtitle: String? = nil,
        titleIcon: UIImage? = nil,
        leftSuffix: CellLeftSideSuffixable? = nil,
        rightSuffix: CellRightSideSuffixable? = nil,
        theme: VintedTheme = .none,
        validation: String? = nil,
        size: CellSize = .normal,
        highlighted: Bool = false,
        disabled: Bool = false,
        accessibilityIdentifier: String? = nil,
        shouldHideTapLayer: Bool = false,
        dividers: [DividerBorder] = [],
        onTap: (() -> ())? = nil) -> Cell {
        return Cell(title: title,
                    subtitle: subtitle,
                    titleIcon: titleIcon,
                    body: self,
                    leftSuffix: leftSuffix,
                    rightSuffix: rightSuffix,
                    theme: theme,
                    validation: validation,
                    size: size,
                    highlighted: highlighted,
                    disabled: disabled,
                    accessibilityIdentifier: accessibilityIdentifier,
                    shouldHideTapLayer: shouldHideTapLayer,
                    dividers: dividers,
                    onTap: onTap
        )
    }
}
