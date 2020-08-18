private let MaxFontPointSize: CGFloat = 21

@objc
public enum VintedFont: Int {
    case medium
    case regular

    fileprivate func fontValue(_ size: CGFloat, allowScaling: Bool = true) -> UIFont {
        UIFont.systemFont(ofSize: size)
    }
}

public func FontMedium(_ size: CGFloat, allowScaling: Bool = true) -> UIFont {
    return VintedFont.medium.fontValue(size, allowScaling: allowScaling)
}

public func FontRegular(_ size: CGFloat, allowScaling: Bool = true) -> UIFont {
    return VintedFont.regular.fontValue(size, allowScaling: allowScaling)
}

public class VintedFontBuilder: NSObject {
    @objc
    public static func vintedFont(_ font: VintedFont, size: CGFloat, allowScaling: Bool = true) -> UIFont {
        return font.fontValue(size, allowScaling: allowScaling)
    }
}
