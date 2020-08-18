public extension API.V2 {
    final class FeedEvents: Route<VintedAPI.FeedEvents> {
        public init(page: Int = 0) {
            super.init(
                endpoint: API.V2.endpoint+"/items",
                method: .get,
                params: [
                    "page": page,
                    "per_page": 20,
                ]
            )
        }
    }
}
