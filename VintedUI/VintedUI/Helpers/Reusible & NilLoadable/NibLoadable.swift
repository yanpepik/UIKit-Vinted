public protocol NibLoadable: AnyObject {
    static func fromNib() -> Self
    static var nib: UINib { get }
}

public extension NibLoadable {
   
    static var nibName: String {
        return "\(self)".components(separatedBy: ".").first ?? ""
    }
    
    static func fromNib() -> Self {
        return nib
            .instantiate(withOwner: nil, options: nil)
            .first(where: { $0 is Self }) as! Self // swiftlint:disable:this force_cast
    }
    
    static var nib: UINib {
        return UINib(nibName: nibName, bundle: Bundle(for: self))
    }
}
