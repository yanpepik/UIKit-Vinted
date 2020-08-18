let BorderWidth: CGFloat = 1.0

private let UnitBase: CGFloat = 4

let DarknessUnit: CGFloat = 0.02
let ClickedDarknessUnit = DarknessUnit * 4
let ClickedRemovalDelay: TimeInterval = 0.075
let DelayToDetectTouchDown: TimeInterval = 0.25
public let AlphaEnabled: CGFloat = 1.0
public let AlphaDisabled: CGFloat = DarknessUnit * 24

extension Int {
    public var units: CGFloat {
        return CGFloat(self) * UnitBase
    }
}

extension CGFloat {
    public var units: CGFloat {
        return self * UnitBase
    }
}

extension Double {
    public var units: CGFloat {
        return CGFloat(self) * UnitBase
    }
}

public enum RadiusSize {
    case none
    case `default`
    case round
    func value(size: CGSize) -> CGFloat {
        switch self {
        case .none: return 0.units
        case .default: return 1.units
        case .round: return min(size.width, size.height) / 2
        }
    }
}

public enum BorderSize {
    case none
    case `default`
    
    var value: CGFloat {
        switch self {
        case .none: return 0.units
        case .default: return BorderWidth
        }
    }
}

func RoundRadiusSize(size: CGSize) -> CGFloat {
    return min(size.width, size.height) / 2
}
