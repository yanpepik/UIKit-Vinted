public class LinkRange: NSObject {
    public let range: NSRange
    public let onTap: (() -> ())?
    
    @objc
    public init(range: NSRange, onTap: (() -> ())? = nil) {
        self.range = range
        self.onTap = onTap
        super.init()
    }
}
