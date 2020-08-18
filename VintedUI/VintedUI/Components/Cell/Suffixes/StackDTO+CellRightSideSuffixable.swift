extension Stack: CellRightSideSuffixable {
    public func preferredRightSideSuffixWidth(view: UIView) -> CGFloat {
        return view.systemLayoutSizeFitting(CGSize.zero).width
    }
}
