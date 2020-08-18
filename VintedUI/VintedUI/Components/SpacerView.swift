class SpacerView: UIView {
    
    // MARK: - Initializers

    public init() {
        super.init(frame: .zero)
        initialize()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    private func initialize() {
        backgroundColor = .clear
    }
}

public class Spacer {
    let direction: StackDirection
    let spacing: SpacerSize
    
    @objc
    public init(direction: StackDirection = .vertical, spacing: SpacerSize) {
        self.direction = direction
        self.spacing = spacing
    }
}

extension Spacer: ViewData {
    public func createView() -> UIView {
        let spacerView = SpacerView()
        setupView(view: spacerView)
        return spacerView
    }

    public func canReuse(view: UIView) -> Bool {
        return view is SpacerView
    }

    public func setupView(view: UIView) {
        if let view = view as? SpacerView {
            setupConstraints(view: view)
        }
    }

    private func setupConstraints(view: SpacerView) {
        view.removeConstraints(view.constraints)
        if direction == .vertical {
            view.addConstraint(NSLayoutConstraint(item: view, attribute: .height, constant: spacing.floatValue))
        } else {
            view.addConstraint(NSLayoutConstraint(item: view, attribute: .width, constant: spacing.floatValue))
        }
    }
}
