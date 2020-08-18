public class ViewHeightCalculator: NSObject {
    private var heightCache: [String: [CGFloat: CGFloat]] = [:]

    @objc
    public func height(for viewData: ViewData, width: CGFloat) -> CGFloat {
        return height(for: viewData, width: width, traitCollection: nil)
    }

    @objc
    public func height(for viewData: ViewData, width: CGFloat, traitCollection: UITraitCollection?) -> CGFloat {
        let prototypeView = viewData.createView()
        var fittingSize = UIView.layoutFittingCompressedSize
        fittingSize.width = width
        return prototypeView.systemLayoutSizeFitting(
            fittingSize,
            withHorizontalFittingPriority: UILayoutPriority.required,
            verticalFittingPriority: UILayoutPriority.defaultLow
        ).height
    }

    @objc
    public func height(for viewData: ViewData, atIndexPath indexPath: IndexPath, width: CGFloat) -> CGFloat {
        return height(for: viewData, atIndexPath: indexPath, width: width, traitCollection: nil)
    }

    @objc
    public func height(for viewData: ViewData, atIndexPath indexPath: IndexPath, width: CGFloat, traitCollection: UITraitCollection?) -> CGFloat {
        let key = cacheKey(forIndexPath: indexPath)
        if let height = heightCache[key]?[width] {
            return height
        }
        let calculatedHeight = height(for: viewData, width: width, traitCollection: traitCollection)

        if var heightCaches = heightCache[key] {
            heightCaches[width] = calculatedHeight
            heightCache[key] = heightCaches
        } else {
            heightCache[key] = [width: calculatedHeight]
        }

        return calculatedHeight
    }

    @objc
    public func height(for viewData: ViewData, atSection section: Int, width: CGFloat) -> CGFloat {
        return height(for: viewData, atSection: section, width: width, traitCollection: nil)
    }

    @objc
    public func height(for viewData: ViewData, atSection section: Int, width: CGFloat, traitCollection: UITraitCollection?) -> CGFloat {
        let key = cacheKey(forSection: section)
        if let height = heightCache[key]?[width] {
            return height
        }
        let calculatedHeight = height(for: viewData, width: width, traitCollection: traitCollection)

        if var heightCaches = heightCache[key] {
            heightCaches[width] = calculatedHeight
            heightCache[key] = heightCaches
        } else {
            heightCache[key] = [width: calculatedHeight]
        }

        return calculatedHeight
    }

    @objc
    public func invalidateCache() {
        heightCache.removeAll()
    }

    @objc
    public func invalidateCache(atIndexPath indexPath: IndexPath) {
        heightCache.removeValue(forKey: cacheKey(forIndexPath: indexPath))
    }

    private func cacheKey(forIndexPath indexPath: IndexPath) -> String {
        return "\(indexPath.section).\(indexPath.row)"
    }

    private func cacheKey(forSection section: Int) -> String {
        return "\(section)"
    }
}
