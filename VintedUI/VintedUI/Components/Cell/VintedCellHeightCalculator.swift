public final class VintedCellHeightCalculator: NSObject {
    let sizeCalculator = VintedCellSizeCalculator(axis: .vertical)

    public func size(for cell: Cell, width: CGFloat, indexPath: IndexPath? = nil) -> CGSize {
        let height: CGFloat
        if let indexPath = indexPath {
            height = self.height(forDTO: cell, atIndexPath: indexPath, width: width)
        } else {
            height = self.height(forDTO: cell, width: width)
        }
        return CGSize(width: width, height: height)
    }
    
    @objc
    public func height(forDTO dto: Cell, width: CGFloat) -> CGFloat {
        return height(forDTO: dto, width: width, traitCollection: nil)
    }

    @objc
    public func height(forDTO dto: Cell, width: CGFloat, traitCollection: UITraitCollection?) -> CGFloat {
        return sizeCalculator.length(forDTO: dto, perpendicularLength: width, traitCollection: traitCollection)
    }

    @objc
    public func height(forDTO dto: Cell, atIndexPath indexPath: IndexPath, width: CGFloat) -> CGFloat {
        return height(forDTO: dto, atIndexPath: indexPath, width: width, traitCollection: nil)
    }

    @objc
    public func height(forDTO dto: Cell,
                       atIndexPath indexPath: IndexPath,
                       width: CGFloat,
                       traitCollection: UITraitCollection?) -> CGFloat {
        return sizeCalculator.length(
            forDTO: dto,
            atIndexPath: indexPath,
            perpendicularLength: width,
            traitCollection: traitCollection
        )
    }

    @objc
    public func invalidateCache() {
        sizeCalculator.invalidateCache()
    }

    @objc
    public func invalidateCache(atIndexPath indexPath: IndexPath) {
        sizeCalculator.invalidateCache(atIndexPath: indexPath)
    }
}

public final class VintedCellWidthCalculator: NSObject {
    let sizeCalculator = VintedCellSizeCalculator(axis: .horizontal)

    @objc
    public func width(forDTO dto: Cell, height: CGFloat) -> CGFloat {
        return width(forDTO: dto, height: height, traitCollection: nil)
    }

    @objc
    public func width(forDTO dto: Cell, height: CGFloat, traitCollection: UITraitCollection?) -> CGFloat {
        return sizeCalculator.length(forDTO: dto, perpendicularLength: height, traitCollection: traitCollection)
    }

    @objc
    public func width(forDTO dto: Cell, atIndexPath indexPath: IndexPath, height: CGFloat) -> CGFloat {
        return width(forDTO: dto, atIndexPath: indexPath, height: height, traitCollection: nil)
    }

    @objc
    public func width(forDTO dto: Cell,
                      atIndexPath indexPath: IndexPath,
                      height: CGFloat,
                      traitCollection: UITraitCollection?) -> CGFloat {
        return sizeCalculator.length(
            forDTO: dto,
            atIndexPath: indexPath,
            perpendicularLength: height,
            traitCollection: traitCollection
        )
    }

    @objc
    public func invalidateCache() {
        sizeCalculator.invalidateCache()
    }

    @objc
    public func invalidateCache(atIndexPath indexPath: IndexPath) {
        sizeCalculator.invalidateCache(atIndexPath: indexPath)
    }
}

private enum Axis: Int {
    case horizontal
    case vertical
}

final class VintedCellSizeCalculator {
    private var cellPrototype: CellView?

    private var lengthCache: [String: [CGFloat: CGFloat]] = [:]
    private var axis: Axis

    fileprivate init(axis: Axis) {
        self.axis = axis
    }

    func length(forDTO dto: Cell, perpendicularLength: CGFloat) -> CGFloat {
        return length(forDTO: dto, perpendicularLength: perpendicularLength, traitCollection: nil)
    }

    func length(forDTO dto: Cell, perpendicularLength: CGFloat, traitCollection: UITraitCollection?) -> CGFloat {
        let prototypeView: CellView

        if dto.bodyHasStack {
            // For some reason height is always 0 for stack view when Stack is reused
            prototypeView = initializePrototypeCell()
        } else {
            prototypeView = cellPrototype ?? initializePrototypeCell()
        }

        cellPrototype = prototypeView
        cellPrototype?.forcedTraitCollection = traitCollection
        var fittingSize = UIView.layoutFittingCompressedSize
        switch axis {
        case .horizontal:
            fittingSize.height = perpendicularLength
        case .vertical:
            fittingSize.width = perpendicularLength
        }
        prototypeView.setup(dto: dto)
        switch axis {
        case .horizontal:
            return prototypeView.systemLayoutSizeFitting(
                fittingSize,
                withHorizontalFittingPriority: UILayoutPriority.defaultLow,
                verticalFittingPriority: UILayoutPriority.required
            ).width
        case .vertical:
            return prototypeView.systemLayoutSizeFitting(
                fittingSize,
                withHorizontalFittingPriority: UILayoutPriority.required,
                verticalFittingPriority: UILayoutPriority.defaultLow
            ).height
        }

    }

    func length(forDTO dto: Cell, atIndexPath indexPath: IndexPath, perpendicularLength: CGFloat) -> CGFloat {
        return length(forDTO: dto, atIndexPath: indexPath, perpendicularLength: perpendicularLength, traitCollection: nil)
    }

    func length(forDTO dto: Cell,
                atIndexPath indexPath: IndexPath,
                perpendicularLength: CGFloat,
                traitCollection: UITraitCollection?) -> CGFloat {

        let key = cacheKey(forIndexPath: indexPath)
        if let length = lengthCache[key]?[perpendicularLength] {
            return length
        }
        let calculatedLength = length(
            forDTO: dto,
            perpendicularLength: perpendicularLength,
            traitCollection: traitCollection
        )

        if var lengthCaches = lengthCache[key] {
            lengthCaches[perpendicularLength] = calculatedLength
            lengthCache[key] = lengthCaches
        } else {
            lengthCache[key] = [perpendicularLength: calculatedLength]
        }

        return calculatedLength
    }

    func invalidateCache() {
        lengthCache.removeAll()
    }

    func invalidateCache(atIndexPath indexPath: IndexPath) {
        lengthCache.removeValue(forKey: cacheKey(forIndexPath: indexPath))
    }

    private func cacheKey(forIndexPath indexPath: IndexPath) -> String {
        return "\(indexPath.section).\(indexPath.row)"
    }

    private func initializePrototypeCell() -> CellView {
        let cell = CellView()
        cell.translatesAutoresizingMaskIntoConstraints = false
        return cell
    }
}

extension Cell {
    fileprivate var bodyHasStack: Bool {
        return body is Stack || ((body as? Cell)?.bodyHasStack == true)
    }
}
