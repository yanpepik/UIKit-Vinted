public extension NSLayoutConstraint {

    convenience init(item view1: AnyObject,
                     attribute attr1: NSLayoutConstraint.Attribute,
                     relatedBy relation: NSLayoutConstraint.Relation = .equal,
                     toItem view2: AnyObject? = nil,
                     attribute attr2: NSLayoutConstraint.Attribute? = nil,
                     multiplier: CGFloat = 1,
                     constant c: CGFloat = 0) {
        let attribute2 = attr2 ?? attr1
        self.init(item: view1,
                  attribute: attr1,
                  relatedBy: relation,
                  toItem: view2,
                  attribute: attribute2,
                  multiplier: multiplier,
                  constant: c)
    }

}
