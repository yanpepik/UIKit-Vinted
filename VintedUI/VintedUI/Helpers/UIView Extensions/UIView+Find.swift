extension UIView {

    public func find(where predicate: (UIView) throws -> Bool) rethrows -> [UIView] {
        var results: [UIView] = try [self].filter(predicate)
        try subviews.forEach { results += try $0.find(where: predicate) }
        return results
    }
}
