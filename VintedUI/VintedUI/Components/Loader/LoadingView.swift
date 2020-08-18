private let AnimationDuration: CFTimeInterval = 2
private let CircleMaxPercentage = 0.9
private let CircleMinPercentage = 0.1
private let AnimationMidPointPercentage = 0.5

final class LoadingView: UIView {
    var lineWidth: CGFloat = 1.units {
        didSet {
            resetShapeLayer()
        }
    }
    var lineColor: UIColor = Color(.grayscale9) {
        didSet {
            shapeLayer?.strokeColor = lineColor.cgColor
        }
    }
    private var shapeLayer: CAShapeLayer?
    private var isAnimating = false

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    private func initialize() {
        backgroundColor = .clear
        setupShapeLayer()
    }

    // MARK: - Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()
        resetShapeLayer()
    }

    private func resetShapeLayer() {
        setupShapeLayer()
        if isAnimating {
            startAnimating()
        }
    }

    // MARK: - Animation

    func startAnimating() {
        isAnimating = true
        shapeLayer?.add(animationGroup(), forKey: "animation")
    }

    func stopAnimating() {
        isAnimating = false
        shapeLayer?.removeAllAnimations()
    }

    // MARK: - Setup

    private func setupShapeLayer() {
        shapeLayer?.removeFromSuperlayer()
        let size = frame.size
        let shorterEdge = min(size.width, size.height)
        let path = UIBezierPath()
        path.addArc(
            withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
            radius: (shorterEdge - lineWidth) / 2,
            startAngle: -(.pi / 2),
            endAngle: .pi + .pi / 2,
            clockwise: true
        )
        let layer = CAShapeLayer()
        layer.fillColor = nil
        layer.strokeColor = lineColor.cgColor
        layer.lineWidth = lineWidth
        layer.backgroundColor = nil
        layer.path = path.cgPath
        layer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        self.layer.addSublayer(layer)
        shapeLayer = layer
    }

    private func animationGroup() -> CAAnimationGroup {
        let firstRotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        firstRotationAnimation.byValue = Float.pi * 2
        firstRotationAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        firstRotationAnimation.duration = AnimationDuration * AnimationMidPointPercentage

        let secondRotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        secondRotationAnimation.byValue = Float.pi * 4
        secondRotationAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        secondRotationAnimation.duration = AnimationDuration * AnimationMidPointPercentage
        secondRotationAnimation.beginTime = AnimationDuration * AnimationMidPointPercentage

        let forwardStrokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
        forwardStrokeAnimation.duration = AnimationDuration * AnimationMidPointPercentage
        forwardStrokeAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        forwardStrokeAnimation.fromValue = CircleMinPercentage
        forwardStrokeAnimation.toValue = CircleMaxPercentage

        let backwardStrokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
        backwardStrokeAnimation.duration = AnimationDuration * AnimationMidPointPercentage
        backwardStrokeAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        backwardStrokeAnimation.fromValue = CircleMaxPercentage
        backwardStrokeAnimation.toValue = CircleMinPercentage
        backwardStrokeAnimation.beginTime = AnimationDuration * AnimationMidPointPercentage

        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [
            forwardStrokeAnimation,
            backwardStrokeAnimation,
            firstRotationAnimation,
            secondRotationAnimation,
        ]
        groupAnimation.duration = AnimationDuration
        groupAnimation.repeatCount = .infinity
        groupAnimation.isRemovedOnCompletion = false
        groupAnimation.fillMode = CAMediaTimingFillMode.forwards
        return groupAnimation
    }
}
