public class TextView: UIView {
    let label = UILabel()
    
    private var tapGesture: UITapGestureRecognizer?

    // MARK: - Initializers

    init() {
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
        embed(view: label, inContainerView: self)
    }
    
    // MARK: - Override
    
    public override func setContentHuggingPriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) {
        label.setContentHuggingPriority(priority, for: axis)
    }
    
    public override func setContentCompressionResistancePriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) {
        label.setContentCompressionResistancePriority(priority, for: axis)
    }
    
    // MARK: - Setup

    @objc
    public func setup(text: AttributedText) {
        guard let attributedText = text.attributedStringForView else {
            label.attributedText = nil
            tapGesture?.isEnabled = false
            return
        }

        label.attributedText = attributedText
        label.accessibilityIdentifier = text.accessibilityIdentifier
        label.numberOfLines = text.numberOfRows
        if label.numberOfLines != 0 {
            label.lineBreakMode = .byTruncatingTail
        }

        if text.hasAnyLinks() {
            if tapGesture == nil {
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOnLabel(sender:)))
                label.isUserInteractionEnabled = true
                tapGesture.delegate = self
                label.addGestureRecognizer(tapGesture)
                self.tapGesture = tapGesture
            }
            tapGesture?.isEnabled = true
        } else {
            tapGesture?.isEnabled = false
        }
    }

    func preferredWidth() -> CGFloat {
        return label.intrinsicContentSize.width
    }

    // MARK: - Actions

    @objc
    private func handleTapOnLabel(sender: UITapGestureRecognizer) {
        let locationOfTouchInLabel = sender.location(in: sender.view)
        if let link = tappedLink(at: locationOfTouchInLabel) {
            link.onTap?()
        }
    }

    private func textLink(at location: Int) -> TextLink? {
        guard let attributedString = label.attributedText else {
            return nil
        }

        let rangeToEnumarate = NSRange(location: 0, length: attributedString.string.count)
        var textLink: TextLink?
        attributedString.enumerateAttribute(
            NSAttributedString.Key(rawValue: TextLinkAttributeName),
            in: rangeToEnumarate,
            options: .longestEffectiveRangeNotRequired,
            using: { (link, range, stop) in
                if let link = link as? TextLink, range.contains(location) {
                    textLink = link
                    stop.pointee = true
                }
            }
        )
        return textLink
    }

    // MARK: - Helpers

    private func tappedLink(at location: CGPoint?) -> TextLink? {
        guard let location = location else {
            return nil
        }

        let layoutManager = NSLayoutManager()

        let textContainer = NSTextContainer(size: label.frame.size)

        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = label.numberOfLines
        textContainer.lineBreakMode = label.lineBreakMode
        layoutManager.addTextContainer(textContainer)

        let textStorage = NSTextStorage(attributedString: label.attributedText ?? NSAttributedString())
        textStorage.addLayoutManager(layoutManager)

        let locationOfTouchInTextContainer = CGPoint(x: location.x, y: location.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)

        return textLink(at: indexOfCharacter)
    }
}

extension TextView: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let locationOfTouchInLabel = touch.location(in: touch.view)
        return tappedLink(at: locationOfTouchInLabel) != nil
    }
}
