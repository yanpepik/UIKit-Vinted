extension AttributedText: CellRightSideSuffixable {
    public func preferredRightSideSuffixWidth(view: UIView) -> CGFloat {
        guard let view = view as? TextView else {
            return 0
        }
        return view.preferredWidth()
    }
}
