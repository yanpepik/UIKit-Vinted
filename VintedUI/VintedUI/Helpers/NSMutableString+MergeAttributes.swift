extension NSMutableAttributedString {
    func mergeAttributes(attributes: [NSAttributedString.Key: Any], inRange range: NSRange) {
        enumerateAttributes(in: range, options: .longestEffectiveRangeNotRequired, using: { attrs, range, _ in
            var newAttrs = attrs
            for (key, value) in attributes {
                newAttrs[key] = value
            }
            
            if range.location + range.length <= length {
                setAttributes(newAttrs, range: range)
            }
        })
    }
}
