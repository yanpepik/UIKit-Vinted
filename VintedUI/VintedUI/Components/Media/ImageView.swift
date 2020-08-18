// http://ui.vinted.net/atoms/image.html

public let ImageStyleDefault = ImageStyle.none
public let ImageScalingDefault = ImageScaling.auto
public let ImageRatioDefault = ImageRatio.landscape

@objc
public enum ImageScaling: Int {
    case auto
    case contain
    case cover
    case fill
    
    var contentMode: UIView.ContentMode {
        switch self {
        case .auto:
            return .center
        case .contain:
            return .scaleAspectFit
        case .cover:
            return .scaleAspectFill
        case .fill:
            return .scaleToFill
        }
    }
}

@objc
public enum ImageStyle: Int {
    case none
    case rounded
    case circle
}

@objc
public enum ImageRatio: Int {
    case square
    case portrait
    case smallPortrait
    case landscape
    case smallLandscape
    
    public var widthToHeightRatio: CGFloat {
        switch self {
        case .square:
            return 1.0
        case .portrait:
            return 2.0 / 3.0
        case .smallPortrait:
            return 3.0 / 4.0
        case .landscape:
            return 3.0 / 2.0
        case .smallLandscape:
            return 4.0/3.0
        }
    }
}

public class ImageView: UIView {
    var imageView: ImageContentView!
    
    private var label: UILabel?
    private var sizeOptions: ImageSize = DefaultImageSize
    private var onTap: ((UIImageView?) -> ())?
    
    private var heightConstraint: NSLayoutConstraint?
    private var widthConstraint: NSLayoutConstraint?
    private var tapGesture: UITapGestureRecognizer!

    override public var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        let height = sizeOptions.heightSize == .unit ? sizeOptions.height : size.height
        let width = sizeOptions.widthSize == .unit ? sizeOptions.width : size.width

        return CGSize(width: width, height: height)
    }

    // MARK: - Initializers

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        initialize()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    // MARK: - Lifecycle

    public override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }
    
    private func initialize() {
        backgroundColor = UIColor.clear
        imageView = ImageContentView(frame: frame)
        imageView.frame = bounds
        addSubview(imageView)
        addTapGestureRecognizers()
    }
    
    private func addTapGestureRecognizers() {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        tapGesture.isEnabled = false
        addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Size calculation
    
    override public func sizeThatFits(_ size: CGSize) -> CGSize {
        // If width and height defined as auto - We can't calculate anything. Fallback to default implementation
        let ratio = sizeOptions.ratio
        
        if sizeOptions.widthSize == .auto && sizeOptions.heightSize == .auto {
            return super.sizeThatFits(size)
        }
        
        var height: CGFloat = size.height
        var width: CGFloat = size.width
        
        if sizeOptions.widthSize == .percentage {
            width = (size.width / 100) * sizeOptions.width
        } else if sizeOptions.widthSize == .unit {
            width = sizeOptions.width
        }
        
        if sizeOptions.heightSize == .percentage {
            height = (size.height / 100) * sizeOptions.height
        } else if sizeOptions.heightSize == .unit {
            height = sizeOptions.height
        }
        
        if sizeOptions.widthSize == .auto {
            width = height * ratio.widthToHeightRatio
        }
        
        if sizeOptions.heightSize == .auto {
            height = width / ratio.widthToHeightRatio
        }
        
        return CGSize(width: width, height: height)
    }
    
    // MARK: - Actions
    
    @objc
    private func imageTapped() {
        onTap?(imageView)
    }
    
    // MARK: - Setup
    
    public func setup(dto: Image) {
        accessibilityIdentifier = dto.accessibilityIdentifier
        imageView.backgroundColor = dto.backgroundColor ?? UIColor.clear
        sizeOptions = dto.size
        onTap = dto.onTap
        tapGesture.isEnabled = onTap != nil
        imageView.setup(dto: dto, addBackgroundLayer: dto.label != nil)
        setupLabel(dto.label, labelStyle: dto.labelStyle)
        setupHeightAndWidth(dto: dto.size)
    }

    private func setupLabel(_ labelText: String?, labelStyle: LabelStyle) {
        if let attributedLabel = attributedText(string: labelText, type: .title, inversed: true, theme: .none, alignment: .center) {
            if label?.superview == nil {
                let label = UILabel()
                label.numberOfLines = 0
                label.text = nil
                let margins = UIEdgeInsets(top: 0, left: labelStyle.padding, bottom: 0, right: labelStyle.padding)
                embed(view: label, inContainerView: self, margins: margins)
                imageView.bringSubviewToFront(label)
                self.label = label
            }
            label?.attributedText = attributedLabel
        } else {
            label?.removeFromSuperview()
        }
    }
    
    private func setupHeightAndWidth(dto: ImageSize) {
        setupAutoLayoutHeightAndWidth(dto: dto)
    }
    
    private func setupAutoLayoutHeightAndWidth(dto: ImageSize) {
        if dto.heightSize == .unit {
            if let heightConstraint = heightConstraint {
                heightConstraint.constant = dto.height
            } else {
                let constraint = NSLayoutConstraint(
                    item: self,
                    attribute: .height,
                    relatedBy: .equal,
                    toItem: nil,
                    attribute: .notAnAttribute,
                    multiplier: 1,
                    constant: dto.height
                )
                addConstraint(constraint)
                heightConstraint = constraint
            }
        } else {
            if let heightConstraint = heightConstraint {
                removeConstraint(heightConstraint)
            }
        }

        if dto.widthSize == .unit {
            if let widthConstraint = widthConstraint {
                widthConstraint.constant = dto.width
            } else {
                let constraint = NSLayoutConstraint(
                    item: self,
                    attribute: .width,
                    relatedBy: .equal,
                    toItem: nil,
                    attribute: .notAnAttribute,
                    multiplier: 1,
                    constant: dto.width
                )
                addConstraint(constraint)
                widthConstraint = constraint
            }
        } else {
            if let widthConstraint = widthConstraint {
                removeConstraint(widthConstraint)
            }
        }
    }
}
