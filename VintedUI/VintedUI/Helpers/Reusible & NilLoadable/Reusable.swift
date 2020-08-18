public protocol Reusable {}

extension Reusable {
    public var reuseIdentifier: String { return "\(type(of: self))" }
    public static var reuseIdentifier: String { return "\(type(of: self))" }
}
