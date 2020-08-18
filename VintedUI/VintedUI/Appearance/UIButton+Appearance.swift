extension UIButton {
    func showsTouchWhenHighlighted(fromBoolNumber showsTouchNumber: Bool) {
        let buttonTitleForNormalState = title(for: .normal)
        if (buttonTitleForNormalState?.count ?? 0) == 0 {
            showsTouchWhenHighlighted = showsTouchNumber
        }
    }

    func setExclusiveTouchFromBoolNumber(_ showsTouchNumber: Bool) {
        isExclusiveTouch = showsTouchNumber
    }
}
