protocol BadgeAppearance {
    var topMargin: CGFloat { get }
    var bottomMargin: CGFloat { get }
    var leftMargin: CGFloat { get }
    var rightMargin: CGFloat { get }

    var marginBetweenIconAndText: CGFloat { get }

    var minHeight: CGFloat { get }
    var minWidth: CGFloat { get }

    var borderColor: UIColor { get }
    var borderWidth: CGFloat { get }
}

struct CircleBadgeAppearance: BadgeAppearance {
    let topMargin: CGFloat = 0.5.units
    let bottomMargin: CGFloat = 0.5.units
    let leftMargin: CGFloat = 0.5.units
    let rightMargin: CGFloat = 0.5.units

    let marginBetweenIconAndText: CGFloat = 0.units

    var minHeight: CGFloat = 3.units
    var minWidth: CGFloat = 3.units

    let borderColor: UIColor = .white
    let borderWidth: CGFloat = 0.5.units
}

struct NormalBadgeAppearance: BadgeAppearance {
    let topMargin: CGFloat = 1.units
    let bottomMargin: CGFloat = 1.units
    let leftMargin: CGFloat = 2.units
    let rightMargin: CGFloat = 2.units

    let marginBetweenIconAndText: CGFloat = 1.units

    var minHeight: CGFloat {
        return 6.units - topMargin - bottomMargin
    }

    var minWidth: CGFloat {
        return 6.units - leftMargin - rightMargin
    }

    let borderColor: UIColor = Color(.grayscale9)
    let borderWidth: CGFloat = 0.25.units
}
