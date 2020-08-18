public enum Shadow {
    case `default`
    case lifted
    case elavated

    fileprivate var blur: CGFloat {
        switch self {
        case .default:
            return 0.5.units / 2
        case .lifted:
            return 1 / 2
        case .elavated:
            return 6.units / 2
        }
    }

    fileprivate var offset: CGSize {
        switch self {
        case .default:
            return .zero
        case .lifted:
            return CGSize(width: 0, height: 0.25.units)
        case .elavated:
            return CGSize(width: 0, height: 2.units)
        }
    }

    fileprivate var opacity: Float {
        switch self {
        case .default:
            return 0.24
        case .lifted:
            return 0.16
        case .elavated:
            return 0.24
        }
    }

    var color: CGColor {
        return Color(.grayscale1).cgColor
    }
}

extension CALayer {
    func apply(shadow: Shadow) {
        shadowOffset = shadow.offset
        shadowOpacity = shadow.opacity
        shadowRadius = shadow.blur
        shadowColor = shadow.color
    }
}
