public extension UIView {
    func constraint(_ attribute: NSLayoutConstraint.Attribute,
                    relatedBy: NSLayoutConstraint.Relation = .equal,
                    constant: CGFloat) -> NSLayoutConstraint {
        NSLayoutConstraint(
            item: self,
            attribute: attribute,
            relatedBy: relatedBy,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: constant
        )
    }
}
