// http://ui.vinted.net/atoms/text.html

@objc
public enum VintedTextType: Int {
    case body
    case heading
    case title
    case subtitle
    case caption
    case label
    case userInput

    public var fontSize: CGFloat {
        switch self {
        case .body:
            return 4.units
        case .heading:
            return 6.units
        case .title:
            return 4.units
        case .subtitle:
            return 3.5.units
        case .caption:
            return 3.units
        case .label:
            return 3.5.units
        case .userInput:
            return 4.units
        }
    }
    
    var lineHeight: CGFloat {
        switch self {
        case .body:
            return 5.5.units
        case .heading:
            return 8.units
        case .title:
            return 5.5.units
        case .subtitle:
            return 4.5.units
        case .caption:
            return 4.units
        case .label:
            return 4.5.units
        case .userInput:
            return 5.5.units
        }
    }

    var font: UIFont {
        switch self {
        case .body, .subtitle, .caption, .label, .userInput:
            return FontRegular(fontSize)
        case .heading, .title:
            return FontMedium(fontSize)
        }
    }
    
    var boldFont: UIFont {
        return FontMedium(fontSize)
    }

    var color: UIColor {
        switch self {
        case .body:
            return Color(.grayscale3)
        case .heading, .title, .userInput:
            return Color(.grayscale1)
        case .caption, .subtitle, .label:
            return Color(.grayscale4)
        }
    }

    var lineSpacePadding: CGFloat {
        return (lineHeight - font.lineHeight) / 2
    }

    var allCaps: Bool {
        switch self {
        case .body, .heading, .title, .subtitle, .caption, .userInput:
            return false
        case .label:
            return true
        }
    }
}

@objc
public enum VintedTextColor: Int {
    case title
    case body
    case muted
    case primary
    case warning
    case inverse
    
    fileprivate func colorValue(alpha: CGFloat) -> UIColor {
        switch self {
        case .title:
            return Color(.grayscale1)
        case .body:
            return Color(.grayscale3)
        case .muted:
            return Color(.grayscale4)
        case .primary:
            return Color(.primary1)
        case .warning:
            return Color(.secondary3)
        case .inverse:
            return Color(.grayscale9)
        }
    }
}

@objc
public enum VintedTextStyle: Int {
    case bold
    case strikethrough
    case none

    func attribute(with type: VintedTextType) -> [NSAttributedString.Key: Any] {
        switch self {
        case .bold:
            return [NSAttributedString.Key.font: type.boldFont]
        case .strikethrough:
            return [
                NSAttributedString.Key.font: type.font,
                NSAttributedString.Key.strikethroughStyle: NSNumber(value: NSUnderlineStyle.single.rawValue),
                NSAttributedString.Key.baselineOffset: 0// Added baseline offset due to bug (iOS 10.3) http://www.openradar.appspot.com/31034683
            ]
        default:
            return [NSAttributedString.Key.font: type.font]
        }
    }
}

let TextLinkAttributeName = "TextLinkAttribute"
typealias TextLinkAttributeHandlerType = () -> ()

func textColor(theme: VintedTheme, type: VintedTextType, inversed: Bool = false, alpha: CGFloat = 1) -> UIColor {
    if inversed {
        return Color(.grayscale9).withAlphaComponent(alpha)
    } else if theme != .none {
        return theme.primaryColor.withAlphaComponent(alpha)
    } else {
        return type.color.withAlphaComponent(alpha)
    }
}

func textAttributes(_ attributes: [TextAttribute: Any]) -> [NSAttributedString.Key: Any] {
    let type = attributes[.type] as? VintedTextType ?? .body
    let theme = attributes[.theme] as? VintedTheme ?? .none
    let inversed = attributes[.inversed] as? Bool ?? false
    let alignment = attributes[.alignment] as? NSTextAlignment ?? .left

    var styles: [VintedTextStyle] = [.none]
    if (attributes[.strikethrough] as? Bool) == true {
        styles.append(.strikethrough)
    }
    if (attributes[.bold] as? Bool) == true {
        styles.append(.bold)
    }

    var attrs = textAttributes(type: type, styles: styles, inversed: inversed, theme: theme, alignment: alignment, ignoreLineSpacing: false, alpha: 1)

    if let link = attributes[.link] as? TextLink {
        attrs.update(other: linkAttributes(theme: theme, inversed: inversed, link: link))
    }

    return attrs
}

public func textAttributes(type: VintedTextType,
                           styles: [VintedTextStyle] = [.none],
                           inversed: Bool = false,
                           theme: VintedTheme = .none,
                           alignment: NSTextAlignment = .left,
                           ignoreLineSpacing: Bool = false,
                           alpha: CGFloat = 1,
                           lineBreakMode: NSLineBreakMode = .byWordWrapping) -> [NSAttributedString.Key: Any] {

    let color = textColor(theme: theme, type: type, inversed: inversed, alpha: alpha)
    
    let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle // swiftlint:disable:this force_cast
    
    if !ignoreLineSpacing {
        paragraphStyle.lineSpacing = type.lineSpacePadding
        paragraphStyle.minimumLineHeight = type.lineHeight - type.lineSpacePadding
        paragraphStyle.maximumLineHeight = type.lineHeight - type.lineSpacePadding
    }
    
    paragraphStyle.lineBreakMode = lineBreakMode
    paragraphStyle.alignment = alignment
    var attributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.foregroundColor: color,
        NSAttributedString.Key.paragraphStyle: paragraphStyle,
    ]

    for style in styles {
        attributes.update(other: style.attribute(with: type))
    }
    return attributes
}

public func attributedText(string: String?,
                           type: VintedTextType,
                           styles: [VintedTextStyle] = [.none],
                           inversed: Bool = false,
                           theme: VintedTheme = .none,
                           alignment: NSTextAlignment = .left,
                           ignoreLineSpacing: Bool = false,
                           linkRange: NSRange? = nil,
                           alpha: CGFloat = 1,
                           lineBreakMode: NSLineBreakMode = .byWordWrapping) -> NSAttributedString? {
    guard let string = string else {
        return nil
    }
    let newString = type.allCaps ? string.uppercased() : string
    let attributes = textAttributes(
        type: type,
        styles: styles,
        inversed: inversed,
        theme: theme,
        alignment: alignment,
        ignoreLineSpacing: ignoreLineSpacing,
        alpha: alpha,
        lineBreakMode: lineBreakMode
    )
    let attributedString = NSMutableAttributedString(
        string: newString,
        attributes: attributes
    )
    if let range = linkRange {
        attributedString.addAttributes(
            linkAttributes(theme: theme, inversed: inversed),
            range: range
        )
    }
    return attributedString
}

public func linkAttributes(theme: VintedTheme, inversed: Bool, link: TextLink? = nil) -> [NSAttributedString.Key: Any] {
    var attributes: [NSAttributedString.Key: Any] = [:]
    let linkColor = Color(inversed ? .grayscale9 : .primary1)
    attributes[NSAttributedString.Key.foregroundColor] = linkColor
    let underlineStyle = inversed ? NSUnderlineStyle.single : []
    let underlineStyleNumber = NSNumber(value: underlineStyle.rawValue)
    attributes[NSAttributedString.Key.underlineStyle] = underlineStyleNumber
    attributes[NSAttributedString.Key(TextLinkAttributeName)] = link
    return attributes
}

public func TextColor(color: VintedTextColor, alpha: CGFloat = 1.0) -> UIColor {
    return color.colorValue(alpha: alpha)
}

public class TextColorPaletteBuilder: NSObject {
    @objc
    public static func color(fromVintedTextColor color: VintedTextColor) -> UIColor {
        return TextColor(color: color)
    }

    @objc
    public static func color(fromVintedTextColor color: VintedTextColor, alpha: CGFloat) -> UIColor {
        return TextColor(color: color, alpha: alpha)
    }
}
