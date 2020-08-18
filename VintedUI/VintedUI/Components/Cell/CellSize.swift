@objc
public enum CellSize: Int {
    case normal
    case narrow
    case wide
    case tight
    
    public var padding: CGFloat {
        switch self {
        case .normal:
            return 4.units
        case .narrow:
            return 2.units
        case .wide:
            return 6.units
        case .tight:
            return 0
        }
    }
    
    public var paddings: UIEdgeInsets {
        return UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    }
    
    var spacing: CGFloat {
        switch self {
        case .normal:
            return 2.units
        case .narrow:
            return 2.units
        case .wide:
            return 3.units
        case .tight:
            return 2.units
        }
    }
}
