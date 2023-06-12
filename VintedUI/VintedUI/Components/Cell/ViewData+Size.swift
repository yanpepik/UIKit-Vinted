import UIKit

private let widthCalculator = VintedCellWidthCalculator()
private let heightCalculator = VintedCellHeightCalculator()

public extension ViewData {
  
    func width(height: CGFloat) -> CGSize {
        guard #available(iOS 13.0, *) else {
            let cell = self as? Cell ?? inCell(size: .tight)
            let width = widthCalculator.width(forDTO: cell, height: height, traitCollection: traitCollection)
            return CGSize(width: width, height: height)
        }
        
        let prototypeView = createView()
        prototypeView.traitCollectionDidChange(nil)
        var size = UIView.layoutFittingCompressedSize
        size.height = height
        size.width = prototypeView.systemLayoutSizeFitting(
           size,
           withHorizontalFittingPriority: .defaultLow,
           verticalFittingPriority: .required
        ).width
        return size
    }
    
    func height(width: CGFloat) -> CGSize {
        guard #available(iOS 13.0, *) else {
            let cell = self as? Cell ?? inCell(size: .tight)
            let height = heightCalculator.height(
                forDTO: cell,
                width: width,
                traitCollection: traitCollection
            )
            return CGSize(width: width, height: height)
        }
        
        let prototypeView = createView()
        var size = UIView.layoutFittingCompressedSize
        size.width = width
        size.height = prototypeView.systemLayoutSizeFitting(
           size,
           withHorizontalFittingPriority: .required,
           verticalFittingPriority: .defaultLow
        ).height
        return size
    }
    
    private var traitCollection: UITraitCollection? {
        let window = VintedUI.ConfigurationManager.shared.configuration.windowProvider.window
        return window?.traitCollection
    }
}
