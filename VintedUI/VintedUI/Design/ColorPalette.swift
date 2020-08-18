// App colors defined here: http://ui.vinted.net/design/colors.html

@objc
public enum VintedColor: Int {
    // Primary colors
    case primary1 // blue
    // Secondary colors
    case secondary1 // green
    case secondary2 // yellow
    case secondary3 // red
    // Grayscale colors
    case grayscale1 // black
    case grayscale2 // dark grey
    case grayscale3 // medium grey
    case grayscale4 // grey
    case grayscale5 // silver grey
    case grayscale6 // light grey
    case grayscale7
    case grayscale8
    case grayscale9 // white
    // Secondary Medium
    case calypsoSecondaryMedium
    case greenSecondaryMedium
    case yellowSecondaryMedium
    case redSecondaryMedium
    // Secondary Light
    case calypsoSecondaryLight
    case greenSecondaryLight
    case yellowSecondaryLight
    case redSecondaryLight

    func colorValue(alpha: CGFloat = 1.0) -> UIColor {
        switch self {
        case .primary1:
            return UIColor(hexString: "#09B1BA", alpha: alpha)!
        case .secondary1:
            return UIColor(hexString: "#00C06D", alpha: alpha)!
        case .secondary2:
            return UIColor(hexString: "#F7C600", alpha: alpha)!
        case .secondary3:
            return UIColor(hexString: "#F03E53", alpha: alpha)!
        case .grayscale1:
            return UIColor(hexString: "#111111", alpha: alpha)!
        case .grayscale2:
            return UIColor(hexString: "#333333", alpha: alpha)!
        case .grayscale3:
            return UIColor(hexString: "#666666", alpha: alpha)!
        case .grayscale4:
            return UIColor(hexString: "#999999", alpha: alpha)!
        case .grayscale5:
            return UIColor(hexString: "#BBBBBB", alpha: alpha)!
        case .grayscale6:
            return UIColor(hexString: "#DDDDDD", alpha: alpha)!
        case .grayscale7:
            return UIColor(hexString: "#EBEDEE", alpha: alpha)!
        case .grayscale8:
            return UIColor(hexString: "#F5F6F7", alpha: alpha)!
        case .grayscale9:
            return UIColor(hexString: "#FFFFFF", alpha: alpha)!
        case .calypsoSecondaryMedium:
            return UIColor(hexString: "#73DCDC", alpha: alpha)!
        case .greenSecondaryMedium:
            return UIColor(hexString: "#80E4AB", alpha: alpha)!
        case .yellowSecondaryMedium:
            return UIColor(hexString: "#F9DD74", alpha: alpha)!
        case .redSecondaryMedium:
            return UIColor(hexString: "#FF8E8E", alpha: alpha)!
        case .calypsoSecondaryLight:
            return UIColor(hexString: "#CAF1EF", alpha: alpha)!
        case .greenSecondaryLight:
            return UIColor(hexString: "#C3F4C9", alpha: alpha)!
        case .yellowSecondaryLight:
            return UIColor(hexString: "#F1EBB2", alpha: alpha)!
        case .redSecondaryLight:
            return UIColor(hexString: "#FFE5E5", alpha: alpha)!
        }
    }
}

public func Color(_ color: VintedColor, alpha: CGFloat = 1.0) -> UIColor {
    return color.colorValue(alpha: alpha)
}

public class ColorPaletteBuilder: NSObject {
    @objc
    public class func color(fromVintedColor color: VintedColor) -> UIColor {
        return Color(color)
    }

    @objc
    public class func color(fromVintedColor color: VintedColor, alpha: CGFloat) -> UIColor {
        return Color(color, alpha: alpha)
    }
}
