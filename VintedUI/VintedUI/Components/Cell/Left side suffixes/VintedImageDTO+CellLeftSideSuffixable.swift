extension Image: CellLeftSideSuffixable {
    public func preferredLeftSideSuffixSize(view: UIView) -> CGSize {
        guard let view = view as? ImageView else {
            return CGSize.zero
        }
        let size = view.intrinsicContentSize
        if size.height == UIView.noIntrinsicMetric || size.width == UIView.noIntrinsicMetric {
            fatalError("When adding ImageView to CellView you must specify image width and height")
        }
        return size
    }
}
