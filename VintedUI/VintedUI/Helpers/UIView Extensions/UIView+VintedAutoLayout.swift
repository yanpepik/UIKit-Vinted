//  Converted to Swift 5.3 by Swiftify v5.3.19197 - https://swiftify.com/
import UIKit

@objc
public extension UIView {

    func addFullWidthAndHeightLayout(for view: UIView) {
        addFullWidthAndHeightLayout(for: view, priority: .required)
    }

    func addFullWidthAndHeightLayout(for view: UIView, priority: UILayoutPriority) {
        addFullHeightLayout(for: view, priority: priority)
        addFullWidthLayout(for: view, priority: priority)
    }

    func addFullWidthLayout(for view: UIView) {
        addFullWidthLayout(for: view, priority: .required)
    }

    func addFullWidthLayout(for view: UIView, priority: UILayoutPriority) {
        assert(view.isDescendant(of: self), "Have you forgot to add view to views hierarchy?")
        addConstraints(UIView.fullWidthLayoutConstraints(for: view, priority: priority))
    }

    func addFullHeightLayout(for view: UIView) {
        addFullHeightLayout(for: view, priority: .required)
    }

    func addFullHeightLayout(for view: UIView, priority: UILayoutPriority) {
        assert(view.isDescendant(of: self), "Have you forgot to add view to views hierarchy?")
        addConstraints(UIView.fullHeightLayoutConstraints(for: view, priority: priority))
    }

    func addFullWidthLayout(for view: UIView, leftMargin left: CGFloat, rightMargin right: CGFloat) {
        addFullWidthLayout(for: view, priority: .required, leftMargin: left, rightMargin: right)
    }

    func addFullWidthLayout(for view: UIView,
                            priority: UILayoutPriority,
                            leftMargin left: CGFloat,
                            rightMargin right: CGFloat) {
        assert(view.isDescendant(of: self), "Have you forgot to add view to views hierarchy?")
        addConstraints(
            UIView.fullWidthLayoutConstraints(
                for: view,
                priority: priority,
                leftMargin: left,
                rightMargin: right
            )
        )
    }

    func addFixedWidthContraint(_ width: CGFloat) {
        addFixedWidthContraint(width, priority: .required)
    }

    func addFixedWidthContraint(_ width: CGFloat, priority: UILayoutPriority) {
        addConstraints(UIView.fixedWidthLayoutConstraints(for: self, width: width, priority: priority))
    }

    func addFixedHeightContraint(_ height: CGFloat) {
        addFixedHeightContraint(height, priority: .required)
    }

    func addFixedHeightContraint(_ height: CGFloat, priority: UILayoutPriority) {
        addConstraints(UIView.fixedHeightLayoutConstraints(for: self, height: height, priority: priority))
    }

    func addCenterYConstraint(for view: UIView) {
        let centerYConstraint = NSLayoutConstraint(
            item: view,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: self,
            attribute: .centerY,
            multiplier: 1.0,
            constant: 0.0
        )
        view.addConstraint(centerYConstraint)
    }

    func addCenterXConstraint(for view: UIView) {
        let centerXConstraint = NSLayoutConstraint(
            item: view,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: self,
            attribute: .centerX,
            multiplier: 1.0,
            constant: 0.0
        )

        view.addConstraint(centerXConstraint)
    }

    class func fullHeightLayoutConstraints(for view: UIView) -> [NSLayoutConstraint] {
        return self.fullHeightLayoutConstraints(for: view, priority: .required)
    }

    class func fullHeightLayoutConstraints(for view: UIView, priority: UILayoutPriority) -> [NSLayoutConstraint] {
        let contraints: [NSLayoutConstraint] = NSLayoutConstraint
            .constraints(
                withVisualFormat: "V:|[childView]|",
                options: [],
                metrics: nil,
                views: ["childView": view]
            )
        for constrain in contraints {
            constrain.priority = priority
        }
        return contraints
    }

    class func fullWidthLayoutConstraints(for view: UIView) -> [NSLayoutConstraint] {
        return self.fullWidthLayoutConstraints(for: view, priority: UILayoutPriority.required)
    }

    class func fullWidthLayoutConstraints(for view: UIView, priority: UILayoutPriority) -> [NSLayoutConstraint] {
        let contraints: [NSLayoutConstraint] = NSLayoutConstraint
            .constraints(
                withVisualFormat: "H:|[childView]|",
                options: [],
                metrics: nil,
                views: ["childView": view]
            )
        for constrain in contraints {
            constrain.priority = priority
        }
        return contraints
    }

    class func fullWidthLayoutConstraints(for view: UIView,
                                          priority: UILayoutPriority,
                                          leftMargin left: CGFloat,
                                          rightMargin right: CGFloat) -> [NSLayoutConstraint] {
        let visualFormatString = "H:|-(\(left))-[childView]-(\(right))-|"

        let contraints = NSLayoutConstraint
            .constraints(
                withVisualFormat: visualFormatString,
                options: [],
                metrics: nil,
                views: ["childView": view]
        )

        for constrain in contraints {
            constrain.priority = priority
        }

        return contraints
    }

    class func fixedWidthLayoutConstraints(for view: UIView,
                                           width: CGFloat,
                                           priority: UILayoutPriority) -> [NSLayoutConstraint] {
        let visualFormatString = "H:[aView(==\(width))]"

        let contraints = NSLayoutConstraint
            .constraints(
                withVisualFormat: visualFormatString,
                options: [],
                metrics: nil,
                views: ["aView": view]
        )

        for constrain in contraints {
            constrain.priority = priority
        }

        return contraints
    }
  
    class func fixedHeightLayoutConstraints(for view: UIView,
                                            height: CGFloat,
                                            priority: UILayoutPriority) -> [NSLayoutConstraint] {
        let visualFormatString = "V:[aView(==\(height))]"

        let contraints = NSLayoutConstraint
            .constraints(
                withVisualFormat: visualFormatString,
                options: [],
                metrics: nil,
                views: ["aView": view]
        )

        for constrain in contraints {
            constrain.priority = priority
        }

        return contraints
    }
}
