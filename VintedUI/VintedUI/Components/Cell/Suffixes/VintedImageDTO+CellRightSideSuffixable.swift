extension Image: CellRightSideSuffixable {
    public func preferredRightSideSuffixWidth(view: UIView) -> CGFloat {
        guard let view = view as? ImageView else {
            return CGFloat.leastNormalMagnitude
        }
        
        let size = view.intrinsicContentSize
        return size.width
    }
}
