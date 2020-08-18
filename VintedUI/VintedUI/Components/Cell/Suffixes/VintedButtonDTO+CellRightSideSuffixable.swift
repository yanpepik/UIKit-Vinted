extension Button: CellRightSideSuffixable {
    public func preferredRightSideSuffixWidth(view: UIView) -> CGFloat {
        guard let view = view as? ButtonView else {
            return 0
        }
        return view.intrinsicContentSize.width
    }
}
