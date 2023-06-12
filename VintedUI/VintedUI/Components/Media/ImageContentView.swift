let ImageRoundedRadius = RadiusSize.default.value(size: .zero)
let ImageDefaultRadius = RadiusSize.none.value(size: .zero)

// Should not be public
final class ImageContentView: UIImageView {
    private var backgroundLayer = CALayer()
    
    private(set) var style: ImageStyle = ImageStyleDefault
    private(set) var scaling: ImageScaling = ImageScalingDefault
    private var activeImageRequest: ImageRequest?
    
    var onImageLoad: (() -> ())?
    
    private var indicator: VintedActivityIndicatorView?
    
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
        backgroundLayer.backgroundColor = Color(.grayscale1, alpha: 0.24).cgColor
        clipsToBounds = true
        layer.masksToBounds = true
        updateAppearance()
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundLayer.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        indicator?.center = CGPoint(x: bounds.midX, y: bounds.midY)
        updateStyle()
    }
    
    // MARK: - Appearance
    
    private func updateAppearance() {
        updateStyle()
        contentMode = scaling.contentMode
    }
    
    private func updateStyle() {
        switch style {
        case .none:
            layer.cornerRadius = ImageDefaultRadius
            backgroundLayer.cornerRadius = ImageDefaultRadius
        case .circle:
            layer.cornerRadius = RoundRadiusSize(size: frame.size)
            backgroundLayer.cornerRadius = RoundRadiusSize(size: frame.size)
        case .rounded:
            layer.cornerRadius = ImageRoundedRadius
            backgroundLayer.cornerRadius = ImageRoundedRadius
        }
    }
    
    // MARK: - Image loading
    
    func setup(dto: Image, addBackgroundLayer: Bool) {
        style = dto.style
        scaling = dto.scaling
        onImageLoad = dto.onImageLoad
        updateAppearance()
        
        if addBackgroundLayer {
            if backgroundLayer.superlayer == nil {
                layer.addSublayer(backgroundLayer)
            }
        } else {
            backgroundLayer.removeFromSuperlayer()
        }
        
        guard let imageSource = dto.source else {
            activeImageRequest = nil
            dto.loadingOptions.showSpinner ? showSpinner() : hideSpinner()
            self.image = nil
            self.tintColor = nil
            return
        }
        
        let request: ImageRequest
        if let targetSize = dto.size.targetSize {
            request = imageSource.request(targetSize: targetSize, scaling: scaling)
        } else {
            request = imageSource.fullSizeRequest
        }
        
        guard activeImageRequest?.identifier != request.identifier else { return }
        activeImageRequest?.cancel()
        activeImageRequest = request
        
        let loadingOptions = dto.loadingOptions
        
        loadingOptions.showSpinner ? showSpinner() : hideSpinner()
        
        if let overrideColor = dto.overrideColor {
            self.image = loadingOptions.placeholder?.withRenderingMode(.alwaysTemplate)
            self.tintColor = Color(overrideColor)
        } else {
            self.image = loadingOptions.placeholder
            self.tintColor = nil
        }
        
        if let cachedImage = request.cachedImage {
            hideSpinner()
            didFinishLoading(cachedImage, overrideColor: dto.overrideColor)
        }
        
        request.perform { [weak self] image in
            self?.hideSpinner()
            guard let image = image, request.identifier == self?.activeImageRequest?.identifier else { return }
            self?.didFinishLoading(image, overrideColor: dto.overrideColor)
        }
    }
    
    private func didFinishLoading(_ image: UIImage, overrideColor: VintedColor?) {
        if let overrideColor = overrideColor {
            self.image = image.withRenderingMode(.alwaysTemplate)
            tintColor = Color(overrideColor)
        } else {
            self.image = image
            self.tintColor = nil
        }
        self.onImageLoad?()
    }

    // MARK: - Activity indicator methods
    
    func showSpinner() {
        if indicator == nil {
            let indicatorView = VintedActivityIndicatorView(style: .medium)
            indicatorView.hidesWhenStopped = true
            indicatorView.center = CGPoint(x: bounds.midX, y: bounds.midY)
            addSubview(indicatorView)
            indicator = indicatorView
        }
        indicator?.startAnimating()
    }
    
    func hideSpinner() {
        indicator?.stopAnimating()
    }
}

private extension ImageSize {
    var targetSize: CGSize? {
        let scale = UIScreen.main.scale
        
        switch (widthSize, heightSize) {
        case (.unit, .unit):
            return CGSize(width: width * scale, height: height * scale)
        case (.unit, .auto):
            return CGSize(width: width * scale, height: (width / ratio.widthToHeightRatio) * scale)
        case (.auto, .unit):
            return CGSize(width: (height / ratio.widthToHeightRatio) * scale, height: height * scale)
        default:
            return nil
        }
    }
}
