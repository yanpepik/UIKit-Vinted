@discardableResult public func embed(view viewToEmbed: UIView, inContainerView containerView: UIView) -> [NSLayoutConstraint] {
    return embed(view: viewToEmbed, inContainerView: containerView, margins: UIEdgeInsets.zero)
}

@discardableResult public func embed(view viewToEmbed: UIView, inContainerView containerView: UIView, margins: UIEdgeInsets) -> [NSLayoutConstraint] {
    viewToEmbed.translatesAutoresizingMaskIntoConstraints = false
    containerView.addSubview(viewToEmbed)
    
    let topContraint = NSLayoutConstraint(
        item: viewToEmbed,
        attribute: .top,
        relatedBy: .equal,
        toItem: containerView,
        attribute: .top,
        multiplier: 1.0,
        constant: margins.top
    )
    
    let bottomConstraint = NSLayoutConstraint(
        item: containerView,
        attribute: .bottom,
        relatedBy: .equal,
        toItem: viewToEmbed,
        attribute: .bottom,
        multiplier: 1.0,
        constant: margins.bottom
    )
    let leftConstraint = NSLayoutConstraint(
        item: viewToEmbed,
        attribute: .leading,
        relatedBy: .equal,
        toItem: containerView,
        attribute: .leading,
        multiplier: 1.0,
        constant: margins.left
    )
    let rightConstraint = NSLayoutConstraint(
        item: containerView,
        attribute: .trailing,
        relatedBy: .equal,
        toItem: viewToEmbed,
        attribute: .trailing,
        multiplier: 1.0,
        constant: margins.right
    )
    
    containerView.addConstraints([topContraint, rightConstraint, bottomConstraint, leftConstraint])
    return [topContraint, rightConstraint, bottomConstraint, leftConstraint]
}

public func embedVertically(view viewToEmbed: UIView, inContainerView containerView: UIView) {
    viewToEmbed.translatesAutoresizingMaskIntoConstraints = false
    containerView.addSubview(viewToEmbed)
    
    let topContraint = NSLayoutConstraint(
        item: viewToEmbed,
        attribute: .top,
        relatedBy: .equal,
        toItem: containerView,
        attribute: .top,
        multiplier: 1.0,
        constant: 0
    )
    
    let bottomConstraint = NSLayoutConstraint(
        item: containerView,
        attribute: .bottom,
        relatedBy: .equal,
        toItem: viewToEmbed,
        attribute: .bottom,
        multiplier: 1.0,
        constant: 0
    )
    containerView.addConstraints([topContraint, bottomConstraint])
}

public func embedAtTop(view viewToEmbed: UIView, inContainerView containerView: UIView) {
    viewToEmbed.translatesAutoresizingMaskIntoConstraints = false
    containerView.addSubview(viewToEmbed)
    
    let topConstraint = NSLayoutConstraint(
        item: containerView,
        attribute: .top,
        relatedBy: .equal,
        toItem: viewToEmbed,
        attribute: .top,
        multiplier: 1.0,
        constant: 0
    )
    let leftConstraint = NSLayoutConstraint(
        item: viewToEmbed,
        attribute: .leading,
        relatedBy: .equal,
        toItem: containerView,
        attribute: .leading,
        multiplier: 1.0,
        constant: 0
    )
    let rightConstraint = NSLayoutConstraint(
        item: containerView,
        attribute: .trailing,
        relatedBy: .equal,
        toItem: viewToEmbed,
        attribute: .trailing,
        multiplier: 1.0,
        constant: 0
    )
    
    containerView.addConstraints([topConstraint, leftConstraint, rightConstraint])
}

public func embedAtBottom(view viewToEmbed: UIView, inContainerView containerView: UIView) {
    viewToEmbed.translatesAutoresizingMaskIntoConstraints = false
    containerView.addSubview(viewToEmbed)
    
    let bottomConstraint = NSLayoutConstraint(
        item: containerView,
        attribute: .bottom,
        relatedBy: .equal,
        toItem: viewToEmbed,
        attribute: .bottom,
        multiplier: 1.0,
        constant: 0
    )
    let leftConstraint = NSLayoutConstraint(
        item: viewToEmbed,
        attribute: .leading,
        relatedBy: .equal,
        toItem: containerView,
        attribute: .leading,
        multiplier: 1.0,
        constant: 0
    )
    let rightConstraint = NSLayoutConstraint(
        item: containerView,
        attribute: .trailing,
        relatedBy: .equal,
        toItem: viewToEmbed,
        attribute: .trailing,
        multiplier: 1.0,
        constant: 0
    )
    
    containerView.addConstraints([bottomConstraint, leftConstraint, rightConstraint])
}

public func embedToLeft(view viewToEmbed: UIView, inContainerView containerView: UIView) {
    embedToLeft(view: viewToEmbed, inContainerView: containerView, margins: UIEdgeInsets.zero)
}

public func embedToLeft(view viewToEmbed: UIView, inContainerView containerView: UIView, margins: UIEdgeInsets) {
    viewToEmbed.translatesAutoresizingMaskIntoConstraints = false
    containerView.addSubview(viewToEmbed)
    
    let topConstraint = NSLayoutConstraint(
        item: viewToEmbed,
        attribute: .top,
        relatedBy: .equal,
        toItem: containerView,
        attribute: .top,
        multiplier: 1.0,
        constant: margins.top
    )
    let bottomConstraint = NSLayoutConstraint(
        item: containerView,
        attribute: .bottom,
        relatedBy: .equal,
        toItem: viewToEmbed,
        attribute: .bottom,
        multiplier: 1.0,
        constant: margins.bottom
    )
    let leftConstraint = NSLayoutConstraint(
        item: viewToEmbed,
        attribute: .leading,
        relatedBy: .equal,
        toItem: containerView,
        attribute: .leading,
        multiplier: 1.0,
        constant: margins.left
    )
    
    containerView.addConstraints([bottomConstraint, topConstraint, leftConstraint])
}

public func embedToRight(view viewToEmbed: UIView, inContainerView containerView: UIView) {
    embedToRight(view: viewToEmbed, inContainerView: containerView, margins: UIEdgeInsets.zero)
}

public func embedToRight(view viewToEmbed: UIView, inContainerView containerView: UIView, margins: UIEdgeInsets) {
    viewToEmbed.translatesAutoresizingMaskIntoConstraints = false
    containerView.addSubview(viewToEmbed)
    
    let topConstraint = NSLayoutConstraint(
        item: viewToEmbed,
        attribute: .top,
        relatedBy: .equal,
        toItem: containerView,
        attribute: .top,
        multiplier: 1.0,
        constant: margins.top
    )
    let bottomConstraint = NSLayoutConstraint(
        item: containerView,
        attribute: .bottom,
        relatedBy: .equal,
        toItem: viewToEmbed,
        attribute: .bottom,
        multiplier: 1.0,
        constant: margins.bottom
    )
    let rightConstraint = NSLayoutConstraint(
        item: containerView,
        attribute: .trailing,
        relatedBy: .equal,
        toItem: viewToEmbed,
        attribute: .trailing,
        multiplier: 1.0,
        constant: margins.right
    )
    
    containerView.addConstraints([bottomConstraint, topConstraint, rightConstraint])
}

public func embedCentre(view viewToEmbed: UIView, inContainerView containerView: UIView) {
    viewToEmbed.translatesAutoresizingMaskIntoConstraints = false
    containerView.addSubview(viewToEmbed)
    
    let centerX = NSLayoutConstraint(
        item: containerView,
        attribute: .centerX,
        relatedBy: .equal,
        toItem: viewToEmbed,
        attribute: .centerX,
        multiplier: 1.0,
        constant: 0
    )
    let centerY = NSLayoutConstraint(
        item: containerView,
        attribute: .centerY,
        relatedBy: .equal,
        toItem: viewToEmbed,
        attribute: .centerY,
        multiplier: 1.0,
        constant: 0
    )
    
    containerView.addConstraints([centerX, centerY])
}

public extension UIView {
    @objc
    @discardableResult func embedInside(_ viewToEmbed: UIView) -> [NSLayoutConstraint] {
        return VintedUI.embed(view: viewToEmbed, inContainerView: self, margins: UIEdgeInsets.zero)
    }
}
