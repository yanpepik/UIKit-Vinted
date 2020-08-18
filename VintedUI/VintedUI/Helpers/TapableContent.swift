public struct TapableContent<ContentType> {
    public let content: ContentType
    public let onTap: () -> ()

    public init(_ content: ContentType, onTap: @escaping () -> ()) {
        self.content = content
        self.onTap = onTap
    }
}

extension TapableContent: Equatable where ContentType: Equatable {
    public static func == (lhs: TapableContent<ContentType>, rhs: TapableContent<ContentType>) -> Bool {
        return lhs.content == rhs.content
    }
}
