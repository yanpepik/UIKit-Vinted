public class AttributedText: NSObject {
    private let attributedString: NSAttributedString?

    let numberOfRows: Int
    let accessibilityIdentifier: String?

    // MARK: - Initialize

    public init(text: String?, attributes: [TextAttribute: Any], numberOfRows: Int = 0, accessibilityIdentifier: String? = nil) {
        self.numberOfRows = numberOfRows
        self.accessibilityIdentifier = accessibilityIdentifier
        if let text = text {
            self.attributedString = NSAttributedString(string: text, attributes: textAttributesToAttributes(attributes))
        } else {
            self.attributedString = nil
        }
        super.init()
    }

    @objc
    public convenience init(text: String?,
                            type: VintedTextType = .body,
                            theme: VintedTheme = .none,
                            inversed: Bool = false,
                            numberOfRows: Int = 0,
                            alignment: NSTextAlignment = .left,
                            accessibilityIdentifier: String? = nil) {
        self.init(
            text: text,
            attributes: [
                .type: type,
                .theme: theme,
                .inversed: inversed,
                .alignment: alignment
            ],
            numberOfRows: numberOfRows,
            accessibilityIdentifier: accessibilityIdentifier
        )
    }

    // Private initializer

    private init(attributedString: NSAttributedString?, numberOfRows: Int, accessibilityIdentifier: String?) {
        self.numberOfRows = numberOfRows
        self.attributedString = attributedString
        self.accessibilityIdentifier = accessibilityIdentifier
        super.init()
    }

    private func newCopy(mutableAttributedString: NSMutableAttributedString) -> AttributedText {
        return AttributedText(
            attributedString: NSAttributedString(attributedString: mutableAttributedString),
            numberOfRows: numberOfRows,
            accessibilityIdentifier: accessibilityIdentifier
        )
    }

    // MARK: - Apply attributes

    public func with(attributes: [TextAttribute: Any], inRange range: NSRange) -> AttributedText {
        guard let mutableAttributedString = mutableAttributedString else {
            return self
        }
        mutableAttributedString.addAttributes(textAttributesToAttributes(attributes), range: range)
        return newCopy(mutableAttributedString: mutableAttributedString)
    }

    public func with(text: String, attributes: [TextAttribute: Any], inRange range: NSRange) -> AttributedText {
        guard let mutableAttributedString = mutableAttributedString else {
            return self
        }

        let newAttributesInRange = textAttributesToAttributes(attributes)
        let newRange = NSRange(location: range.location, length: text.count)
        mutableAttributedString.replaceCharacters(in: range, with: text)
        mutableAttributedString.addAttributes(newAttributesInRange, range: newRange)
        return newCopy(mutableAttributedString: mutableAttributedString)
    }

    public func with(attributes: [TextAttribute: Any], inRanges ranges: [NSRange]) -> AttributedText {
        guard let mutableAttributedString = mutableAttributedString else {
            return self
        }
        ranges.forEach { range in
            mutableAttributedString.addAttributes(textAttributesToAttributes(attributes), range: range)
        }
        return newCopy(mutableAttributedString: mutableAttributedString)
    }

    public func replace(textToReplace: String, with newText: String, attributes: [TextAttribute: Any]) -> AttributedText {
        guard let attributedString = attributedString else {
            return self
        }

        let rangeOfTextToReplace = (attributedString.string as NSString).range(of: textToReplace)
        guard rangeOfTextToReplace.location != NSNotFound else {
            return self
        }

        return with(text: newText, attributes: attributes, inRange: rangeOfTextToReplace)
    }

    // MARK: - Apply links

    @objc
    public func linkified(_ link: TextLink) -> AttributedText {
        guard let attributedString = attributedString else {
            return self
        }

        return linkified(link, inRange: NSRange(location: 0, length: attributedString.string.count))
    }

    @objc
    public func linkified(onTap: @escaping () -> ()) -> AttributedText {
        return linkified(TextLink(onTap: onTap))
    }
    
    @objc
    public func linkified(_ occurrences: String, onTap: @escaping () -> ()) -> AttributedText {
        guard let range = attributedString?.string.range(of: occurrences) else {
            return self
        }
        return linkified(.init(onTap: onTap), in: range)
    }
    
    public func linkified(in range: Range<String.Index>, onTap: @escaping () -> ()) -> AttributedText {
        return linkified(.init(onTap: onTap), in: range)
    }
    
    @available(*, deprecated, message: "Use linkified(:, onTap:)")
    public func linkified(_ link: TextLink, for occurrences: String) -> AttributedText {
        guard let range = attributedString?.string.range(of: occurrences) else {
            return self
        }
        return linkified(link, in: range)
    }
    
    public func linkified(_ link: TextLink, inRange range: NSRange) -> AttributedText {
        return linkified(links: [(range, link)])
    }
    
    public func linkified(_ link: TextLink, in range: Range<String.Index>) -> AttributedText {
        guard let text = attributedString?.string else { return self }
        
        let location = range.lowerBound.utf16Offset(in: text)
        let length = range.upperBound.utf16Offset(in: text) - location
        return linkified(link, inRange: NSRange(location: location, length: length))
    }

    public func linkified(links: [(NSRange, TextLink)]) -> AttributedText {
        var attributedText = self

        for (range, link) in links {
            attributedText = attributedText.with(attributes: [.link: link], inRange: range)
        }

        return attributedText
    }

    // MARK: - Replace text to link
    
    public func linkified(textToLinkify: String, withLink link: TextLink, text: String) -> AttributedText {
        guard let attributedString = attributedString else {
            return self
        }

        let rangeOfTextToReplace = (attributedString.string as NSString).range(of: textToLinkify)
        guard rangeOfTextToReplace.location != NSNotFound else {
            return self
        }

        return with(text: text, attributes: [.link: link], inRange: rangeOfTextToReplace)
    }

    // MARK: - Apply style

    public func styled(_ style: VintedTextStyle, inRange range: Range<String.Index>) -> AttributedText {
        guard let attributedString = attributedString else { return self }
        return styled(style, inRange: NSRange(range, in: attributedString.string))
    }
    
    public func styled(_ style: VintedTextStyle, inRange range: NSRange) -> AttributedText {
        switch style {
        case .none:
            return self
        case .bold:
            return with(attributes: [.bold: true], inRange: range)
        case .strikethrough:
            return with(attributes: [.strikethrough: true], inRange: range)
        }
    }

    // MARK: - Apply theme

    public func themed(_ theme: VintedTheme, inRange range: NSRange) -> AttributedText {
        return with(attributes: [.theme: theme], inRange: range)
    }

    public func themed(_ theme: VintedTheme, inRange range: Range<String.Index>?) -> AttributedText {
        guard let attributedString = attributedString, let range = range else { return self }
        return themed(theme, inRange: NSRange(range, in: attributedString.string))
    }

    public func replace(textToReplace: String, with newText: String, theme: VintedTheme) -> AttributedText {
        guard let attributedString = attributedString else {
            return self
        }

        let rangeOfTextToReplace = (attributedString.string as NSString).range(of: textToReplace)
        guard rangeOfTextToReplace.location != NSNotFound else {
            return self
        }

        return with(text: newText, attributes: [.theme: theme], inRange: rangeOfTextToReplace)
    }

    // MARK: - Helpers

    private var mutableAttributedString: NSMutableAttributedString? {
        guard let attributedString = attributedString else {
            return nil
        }
        return NSMutableAttributedString(attributedString: attributedString)
    }

    // MARK: - Internal

    var attributedStringForView: NSAttributedString? {
        guard let attributedString = attributedString else {
            return nil
        }

        let mutableAttributedString = NSMutableAttributedString(string: attributedString.string)
        let rangeToEnumarate = NSRange(location: 0, length: attributedString.string.utf16.count)
        attributedString.enumerateAttributes(
            in: rangeToEnumarate,
            options: .longestEffectiveRangeNotRequired,
            using: { (textAttributes, range, _) in
                let textAttributes = attributesToTextAttributes(textAttributes)
                mutableAttributedString.addAttributes(VintedUI.textAttributes(textAttributes), range: range)
            }
        )

        return NSAttributedString(attributedString: mutableAttributedString)
    }

    func hasAnyLinks() -> Bool {
        guard let attributedString = attributedString else {
            return false
        }

        let rangeToEnumarate = NSRange(location: 0, length: attributedString.string.count)
        var linkFound = false
        attributedString.enumerateAttribute(
            TextAttribute.link.key,
            in: rangeToEnumarate,
            options: .longestEffectiveRangeNotRequired,
            using: { (link, _, stop) in
                if link != nil {
                    linkFound = true
                    stop.pointee = true
                }
            }
        )
        return linkFound
    }
}

private func attributesToTextAttributes(_ attributes: [NSAttributedString.Key: Any]) -> [TextAttribute: Any] {
    var newAttributes: [TextAttribute: Any] = [:]

    for (key, value) in attributes {
        if let textAttribute = attributedStringKeyToTextAttribute(key) {
            newAttributes[textAttribute] = value
        }
    }

    return newAttributes
}

private func textAttributesToAttributes(_ attributes: [TextAttribute: Any]) -> [NSAttributedString.Key: Any] {
    var newAttributes: [NSAttributedString.Key: Any] = [:]

    for (key, value) in attributes {
        newAttributes[key.key] = value
    }

    return newAttributes
}

extension AttributedText: ViewData {
    public func createView() -> UIView {
        let view = TextView()
        view.setup(text: self)
        return view
    }

    public func canReuse(view: UIView) -> Bool {
        return view is TextView
    }

    public func setupView(view: UIView) {
        guard let view = view as? TextView else {
            return
        }
        view.setup(text: self)
    }
}
