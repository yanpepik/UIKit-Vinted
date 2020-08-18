public enum TextAttribute {
    case type
    case theme
    case strikethrough
    case bold
    case link
    case inversed
    case alignment

    var key: NSAttributedString.Key {
        switch self {
        case .type:
            return NSAttributedString.Key(rawValue: "TextAttributeType")
        case .theme:
            return NSAttributedString.Key(rawValue: "TextAttributeTheme")
        case .strikethrough:
            return NSAttributedString.Key(rawValue: "TextAttributeStrikethrough")
        case .bold:
            return NSAttributedString.Key(rawValue: "TextAttributeBold")
        case .link:
            return NSAttributedString.Key(rawValue: "TextAttributeLink")
        case .inversed:
            return NSAttributedString.Key(rawValue: "TextAttributeInversed")
        case .alignment:
            return NSAttributedString.Key(rawValue: "TextAttributeAlignment")
        }
    }
}

private let TextAttributesMap: [NSAttributedString.Key: TextAttribute] = [
    TextAttribute.type.key: .type,
    TextAttribute.theme.key: .theme,
    TextAttribute.strikethrough.key: .strikethrough,
    TextAttribute.bold.key: .bold,
    TextAttribute.inversed.key: .inversed,
    TextAttribute.alignment.key: .alignment,
    TextAttribute.link.key: .link
]

func attributedStringKeyToTextAttribute(_ key: NSAttributedString.Key) -> TextAttribute? {
    return TextAttributesMap[key]
}
