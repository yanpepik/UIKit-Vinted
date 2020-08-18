@objc
public enum VintedTheme: Int {
    case primary
    case muted
    case success
    case warning
    case amplified
    case none
    case transparent
    case expose
    
    var primaryColor: UIColor {
        switch self {
        case .primary:
            return Color(.primary1)
        case .muted:
            return Color(.grayscale4)
        case .success:
            return Color(.secondary1)
        case .warning:
            return Color(.secondary3)
        case .amplified:
            return Color(.grayscale1)
        case .expose:
            return Color(.secondary2)
        case .none, .transparent:
            return UIColor.clear
        }
    }
}
