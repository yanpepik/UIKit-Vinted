public extension UIEdgeInsets {
    func with(top newTop: CGFloat? = nil,
              left newLeft: CGFloat? = nil,
              bottom newBottom: CGFloat? = nil,
              right newRight: CGFloat? = nil) -> UIEdgeInsets {
        return .init(
            top: newTop ?? top,
            left: newLeft ?? left,
            bottom: newBottom ?? bottom,
            right: newRight ?? right
        )
    }

    static func top(_ top: SpacerSize) -> UIEdgeInsets {
        UIEdgeInsets().with(top: top.floatValue)
    }

    static func left(_ left: SpacerSize) -> UIEdgeInsets {
        UIEdgeInsets().with(top: left.floatValue)
    }

    static func bottom(_ bottom: SpacerSize) -> UIEdgeInsets {
        UIEdgeInsets().with(top: bottom.floatValue)
    }

    static func right(_ right: SpacerSize) -> UIEdgeInsets {
        UIEdgeInsets().with(top: right.floatValue)
    }

    static var bottomSafeArea: Self {
        .init(
            top: .zero,
            left: .zero,
            bottom: UIApplication.safeAreaInsets.bottom,
            right: .zero
        )
    }

    static func + (left: Self, right: Self) -> Self {
        .init(
            top: left.top + right.top,
            left: left.left + right.left,
            bottom: left.bottom + right.bottom,
            right: left.right + right.right
        )
    }
}
