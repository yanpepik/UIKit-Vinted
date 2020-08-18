extension ViewData {
    public func stacked(direction: StackDirection, alignment: StackAligment) -> Stack {
        return Stack(items: [self], direction: direction, alignment: alignment)
    }
}

extension Array where Element: ViewData {
    public func stacked(direction: StackDirection = .vertical,
                        alignment: StackAligment = .fill,
                        distribution: StackDistribution = .fill,
                        spacing: SpacerSize = .none) -> Stack {
        return Stack(
            items: self,
            direction: direction,
            alignment: alignment,
            distribution: distribution,
            spacing: spacing
        )
    }
}

public enum HorizontalAlignment {
    case left, right, center
    
    var stackAlignment: StackAligment {
        switch self {
        case .left:
            return .leading
        case .right:
            return .trailing
        case .center:
            return .center
        }
    }
}

public enum VerticalAlignment {
    case top, bottom, center
    
    var stackAlignment: StackAligment {
        switch self {
        case .top:
            return .top
        case .bottom:
            return .bottom
        case .center:
            return .center
        }
    }
}

extension ViewData {
    
    public func aligned(horizontal: HorizontalAlignment = .left,
                        vertically: VerticalAlignment = .center) -> ViewData {
        return [self]
            .stacked(direction: .horizontal, alignment: vertically.stackAlignment)
            .stacked(direction: .vertical, alignment: horizontal.stackAlignment)
    }
}
