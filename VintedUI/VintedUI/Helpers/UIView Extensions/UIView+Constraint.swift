extension UIView {

    @discardableResult func reconstraint(in container: UIView, with margins: UIEdgeInsets) -> [NSLayoutConstraint] {
        guard superview == container else {
            return []
        }
        translatesAutoresizingMaskIntoConstraints = false

        let topContraint = NSLayoutConstraint(
            item: self,
            attribute: .top,
            relatedBy: .equal,
            toItem: container,
            attribute: .top,
            multiplier: 1.0,
            constant: margins.top
        )
        let bottomConstraint = NSLayoutConstraint(
            item: container,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: self,
            attribute: .bottom,
            multiplier: 1.0,
            constant: margins.bottom
        )
        let leftConstraint = NSLayoutConstraint(
            item: self,
            attribute: .leading,
            relatedBy: .equal,
            toItem: container,
            attribute: .leading,
            multiplier: 1.0,
            constant: margins.left
        )
        let rightConstraint = NSLayoutConstraint(
            item: container,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: self,
            attribute: .trailing,
            multiplier: 1.0,
            constant: margins.right
        )
        let insertions = [
            topContraint,
            rightConstraint,
            bottomConstraint,
            leftConstraint
        ]
        let deletions = container
            .constraints
            .filter {
                $0.isMarginal && $0.contains(self)
            }

        container.removeConstraints(deletions)
        container.addConstraints(insertions)

        return insertions
    }
}

private extension NSLayoutConstraint {

    var isMarginal: Bool {
        let attributes: [NSLayoutConstraint.Attribute] = [.top, .bottom, .leading, .trailing]

        let isMargins = attributes.contains(firstAttribute) && attributes.contains(secondAttribute)
        let isAttributedEqually = firstAttribute == secondAttribute

        return isMargins && isAttributedEqually
    }

    func contains(_ view: UIView) -> Bool {
        let items = [
            firstItem as? UIView,
            secondItem as? UIView
        ]
        return items.contains(view)
    }
}
