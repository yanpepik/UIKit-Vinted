// http://ui.vinted.net/atoms/icon.html

final class IconView: UIView, NibLoadable {
    private var imageView: ImageView!
    private var onTap: (() -> ())?

    // MARK: - Initializers

    init() {
        super.init(frame: .zero)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    private func initialize() {
        self.imageView = ImageView()
        embed(view: imageView, inContainerView: self)
        backgroundColor = UIColor.clear
    }
    
    // MARK: - Setup
    
    func setup(dto: Icon) {
        self.onTap = dto.onTap
        let imageSize = ImageSize(iconSize: dto.size)

        let imageTapHandler: ((UIImageView?) -> ())?

        if onTap != nil {
            imageTapHandler = { [weak self] _ in
                self?.onTap?()
            }
        } else {
            imageTapHandler = nil
        }

        let image = Image(
            imageToLoad: dto.loadableImage,
            size: imageSize,
            style: .none,
            scaling: dto.loadableImage?.url != nil ? .contain : .auto,
            label: nil,
            backgroundColor: nil,
            overrideColor: dto.color,
            onTap: imageTapHandler,
            onImageLoad: nil
        )

        image.setupView(view: imageView)
        imageView.accessibilityIdentifier = dto.accessabilityIdentifier
    }
}
