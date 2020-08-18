@objc
public extension UIView {
    // MARK: - View accessors

    var origin: CGPoint {
        get {
            return frame.origin
        }
        set {
            var newFrame = frame
            newFrame.origin = newValue
            frame = newFrame
        }
    }

    var size: CGSize {
        get {
            return frame.size
        }
        set {
            var newFrame = frame
            newFrame.size = newValue
            frame = newFrame
        }
    }

    var height: CGFloat {
        get {
            return size.height
        }
        set {
            var newSize = size
            newSize.height = newValue
            size = newSize
        }
    }

    var width: CGFloat {
        get {
            return size.width
        }
        set {
            var newSize = size
            newSize.width = newValue
            size = newSize
        }
    }

    var boundsWidth: CGFloat {
        get {
            return bounds.width
        }
        set {
            var newBounds = bounds
            newBounds.size = CGSize(width: newValue, height: bounds.height)
            bounds = newBounds
        }
    }

    var boundsHeight: CGFloat {
        get {
            return bounds.height
        }
        set {
            var newBounds = bounds
            newBounds.size = CGSize(width: bounds.width, height: newValue)
            bounds = newBounds
        }
    }

    var x: CGFloat {
        get {
            return center.x
        }
        set {
            center = CGPoint(x: newValue, y: y)
        }
    }

    var y: CGFloat {
        get {
            return center.y
        }
        set {
            center = CGPoint(x: x, y: newValue)
        }
    }

    var top: CGFloat {
        get {
            return origin.y
        }
        set {
            var newFrame = frame
            newFrame.origin = CGPoint(x: frame.origin.x, y: newValue)
            frame = newFrame
        }
    }

    var left: CGFloat {
        get {
            return origin.x
        }
        set {
            var newFrame = frame
            newFrame.origin = CGPoint(x: newValue, y: origin.y)
            frame = newFrame
        }
    }
}
