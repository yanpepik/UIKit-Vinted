public final class RefreshControl: UIRefreshControl {
    public var onRefresh: (() -> ())?

    public init(offset: CGFloat = 0) {
        super.init()
        configure(offset: offset)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure(offset: CGFloat) {
        tintColor = Color(.grayscale5)
        addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        bounds = bounds.offsetBy(dx: 0, dy: offset)
    }

    @objc private func valueChanged() {
        onRefresh?()
    }
}
