extension ActivityIndicator: CellRightSideSuffixable {
    public func preferredRightSideSuffixWidth(view: UIView) -> CGFloat {
        guard let view = view as? VintedActivityIndicatorView else {
            return 0
        }
        return view.intrinsicContentSize.width
    }
}
