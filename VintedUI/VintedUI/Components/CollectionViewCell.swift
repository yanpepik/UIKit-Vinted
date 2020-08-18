public class CollectionViewCell: UICollectionViewCell, NibLoadable {
    private var addedView: UIView?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        contentView.autoresizingMask.insert(.flexibleHeight)
        contentView.autoresizingMask.insert(.flexibleWidth)
    }

    @objc
    public func setup(_ data: ViewData) {
        if let addedView = addedView {
            if data.canReuse(view: addedView) {
                data.setupView(view: addedView)
            } else {
                addedView.removeFromSuperview()
                add(view: data.createView())
            }
        } else {
            add(view: data.createView())
        }
    }

    private func add(view: UIView) {
        embed(view: view, inContainerView: contentView)
        addedView = view
    }

    public override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        return layoutAttributes
    }

    // MARK: - UIResponder override

    override public var canBecomeFirstResponder: Bool {
        return addedView?.canBecomeFirstResponder ?? false
    }

    @discardableResult override public func becomeFirstResponder() -> Bool {
        return addedView?.becomeFirstResponder() ?? false
    }

    override public var canResignFirstResponder: Bool {
        return addedView?.canResignFirstResponder ?? false
    }

    @discardableResult override public func resignFirstResponder() -> Bool {
        return addedView?.resignFirstResponder() ?? false
    }

    override public var isFirstResponder: Bool {
        return addedView?.isFirstResponder ?? false
    }
}
