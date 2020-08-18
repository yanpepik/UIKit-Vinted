extension NSAttributedString {
    func substringThatFitsToSize(_ size: CGSize, withTail tail: NSAttributedString) -> NSAttributedString {
        return substring(
            toFitSize: size,
            index: string.count,
            maxLength: string.count,
            withTail: tail
        )
    }
    
    private func fits(inSize size: CGSize) -> Bool {
        let boundingSize = CGSize(
            width: size.width,
            height: CGFloat.greatestFiniteMagnitude
        )
        let fittingHeight = boundingRect(
            with: boundingSize,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        ).size.height
        return fittingHeight <= size.height
    }
    
    private func substring(toCharacter index: Int, withTail tail: NSAttributedString) -> NSAttributedString {
        let substringIndex = string.index(string.startIndex, offsetBy: index)
        let substring = string[..<substringIndex]
        let mutableAttributedSubstring = NSMutableAttributedString(
            attributedString: attributedSubstring(
                from: NSRange(
                    location: 0,
                    length: substring.count
                )
            )
        )
        mutableAttributedSubstring.append(tail)
        return mutableAttributedSubstring
    }
    
    private func substring(toFitSize size: CGSize,
                           index: Int,
                           maxLength: Int,
                           withTail tail: NSAttributedString) -> NSAttributedString {
        if index == 0 {
            return NSAttributedString(string: "")
        }
        
        let attributedSubstring = substring(toCharacter: index, withTail: tail)
        if attributedSubstring.fits(inSize: size) {
            if index == maxLength {
                return attributedSubstring
            } else {
                let newIndexToCheck = maxLength - (maxLength - index) / 2
                if substring(toCharacter: newIndexToCheck, withTail: tail).fits(inSize: size) {
                    return substring(toFitSize: size, index: newIndexToCheck, maxLength: maxLength, withTail: tail)
                } else if newIndexToCheck == maxLength {
                    return attributedSubstring
                } else {
                    return substring(toFitSize: size, index: index, maxLength: newIndexToCheck, withTail: tail)
                }
            }
        } else {
            return substring(
                toFitSize: size,
                index: index / 2,
                maxLength: index,
                withTail: tail
            )
        }
    }
}
