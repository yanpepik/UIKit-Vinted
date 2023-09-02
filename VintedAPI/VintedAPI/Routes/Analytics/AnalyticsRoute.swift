import Foundation

public final class AnalyticsRoute: Route<Empty> {
    public struct Params: Encodable {
        let items: [Item]

        public init(items: [Item]) {
            self.items = items
        }

        public struct Item: Encodable {
            let id: Int
            let timestamp: Int

            public init(id: Int, timestamp: Int) {
                self.id = id
                self.timestamp = timestamp
            }
        }
    }

    public init(params: Params) {
        super.init(
            baseURL: Portal.current.apiDomain,
            endpoint: "/impressions",
            method: .post,
            params: params
        )
    }
}
