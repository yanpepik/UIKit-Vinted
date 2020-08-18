//: Playground - noun: a place where people can play

import UIKit

public class RoundedCornerView: UIView {
    var borderColor: UIColor = Color(.grayscale1) {
        didSet {
            setNeedsDisplay()
        }
    }

    /// The width of the border.
    var borderWidth: CGFloat = 1 / UIScreen.main.scale {
        didSet {
            setNeedsDisplay()
        }
    }

    /// The drawn corner radius.
    var cornerRadius: CGFloat = 30 {
        didSet {
            setNeedsDisplay()
        }
    }

    /// The color that the rectangle will be filled with.
    var fillColor: UIColor = Color(.grayscale9) {
        didSet {
            setNeedsDisplay()
        }
    }

    var shadowColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }

    override public var bounds: CGRect {
        didSet {
            setNeedsDisplay()
        }
    }

    // MARK: UIView Methods

    override public func draw(_ rect: CGRect) {
        let borderPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        borderColor.set()
        borderPath.fill()

        let fillRect = CGRect(
            x: borderWidth,
            y: borderWidth,
            width: bounds.width - (2 * borderWidth),
            height: bounds.height - (2 * borderWidth)
        )
        let preferedCornerRadius = min(cornerRadius, bounds.width / 2)
        let fillPath = UIBezierPath(roundedRect: fillRect, cornerRadius: preferedCornerRadius)
        fillColor.set()
        fillPath.fill()

        if let shadowColor = shadowColor {
            layer.shadowColor = shadowColor.cgColor
            layer.shadowOffset = CGSize.zero
            layer.shadowOpacity = 0.5
            layer.shadowPath = fillPath.cgPath
        } else {
            layer.shadowPath = nil
            layer.shadowColor = nil
            layer.shadowOpacity = 0
            layer.shadowOffset = CGSize.zero
        }
        super.draw(rect)
    }
}
