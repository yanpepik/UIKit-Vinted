public class TextLink: NSObject {
    let onTap: (() -> ())?

    @objc
    public init(onTap: (() -> ())?) {
        self.onTap = onTap
        super.init()
    }
}
