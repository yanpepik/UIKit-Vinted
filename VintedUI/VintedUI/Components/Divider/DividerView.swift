@objc
public enum DividerOrientation: Int {
    case horizontal
    case vertical
    
    fileprivate var intrinsicContentSize: CGSize {
        switch self {
        case .horizontal:
            return CGSize(width: UIView.noIntrinsicMetric, height: DividerThickness)
        case .vertical:
            return CGSize(width: DividerThickness, height: UIView.noIntrinsicMetric)
        }
    }
}

public class DividerView: UIView {
    
    @IBInspectable public var orientationInt: Int {
        get {
            return orientation.rawValue
        }
        set {
            orientation = DividerOrientation(rawValue: newValue) ?? orientation
            invalidateIntrinsicContentSize()
        }
    }
    
    public var color: UIColor? {
        didSet {
            setup()
        }
    }
    public var orientation: DividerOrientation = .horizontal
    public var inverse: Bool = false {
        didSet {
            setup()
        }
    }

    override public var intrinsicContentSize: CGSize {
        return orientation.intrinsicContentSize
    }
    
    // MARK: - Initializers

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        setup()
    }
    
    // MARK: - Setup
    
    public func setup() {
        if let color = color {
            backgroundColor = color
        } else {
            backgroundColor = inverse ? DividerColorInverse : DividerColor
        }
    }
    
    public func setup(dto: DividerDTO) {
        orientation = dto.orientation
        inverse = dto.inversed
        setup()
    }
}
