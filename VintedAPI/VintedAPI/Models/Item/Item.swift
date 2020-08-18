import Foundation

public struct Item: Decodable {
    public let id: Int
    public let price: Decimal
    public let brand: String
    public let category: String
    private let photo: String
}

extension Item {
    public var image: URL? {
        URL(string: Portal.current.apiDomain + "/images/" + photo)
    }
}
