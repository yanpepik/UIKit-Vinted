final class ComponentCollectionViewCell: UICollectionViewCell {
    private var componentView: UIView?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var componentFrame = frame
        componentFrame.origin = .zero
        componentView?.frame = componentFrame
    }
    
    public override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        return layoutAttributes
    }
        
    override public var canBecomeFirstResponder: Bool {
        return componentView?.canBecomeFirstResponder ?? false
    }
    
    @discardableResult override public func becomeFirstResponder() -> Bool {
        return componentView?.becomeFirstResponder() ?? false
    }
    
    override public var canResignFirstResponder: Bool {
        return componentView?.canResignFirstResponder ?? false
    }
    
    @discardableResult override public func resignFirstResponder() -> Bool {
        return componentView?.resignFirstResponder() ?? false
    }

    override public var isFirstResponder: Bool {
        return componentView?.isFirstResponder ?? false
    }
    
    func setup(_ component: ViewData) {
        if let componentView = componentView, component.canReuse(view: componentView) {
            component.setupView(view: componentView)
        } else {
            componentView?.removeFromSuperview()
            let view = component.createView()
            embed(view: view, inContainerView: contentView)
            componentView = view
        }
    }
}
