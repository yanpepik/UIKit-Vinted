@objc
public enum SpacerSize: Int, Equatable {
    case none
    case xSmall
    case small
    case regular
    case medium
    case large
    case xLarge
    case xxLarge
    case xxxLarge
    case xxxxLarge
    case xxxxxLarge
    case xxxxxxLarge
    
    public var floatValue: CGFloat {
        switch self {
        case .none:
            return 0
        case .xSmall:
            return 0.5.units
        case .small:
            return 1.units
        case .regular:
            return 2.units
        case .medium:
            return 3.units
        case .large:
            return 4.units
        case .xLarge:
            return 6.units
        case .xxLarge:
            return 8.units
        case .xxxLarge:
            return 12.units
        case .xxxxLarge:
            return 16.units
        case .xxxxxLarge:
            return 24.units
        case .xxxxxxLarge:
            return 32.units
        }
    }
    
    public var margins: UIEdgeInsets {
        let padding = floatValue
        return UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    }
}

// for obj-c

public class SpacerSizeFloatValue: NSObject {
    @objc
    public class func fromSpacer(_ spacer: SpacerSize) -> CGFloat {
        return spacer.floatValue
    }
}
