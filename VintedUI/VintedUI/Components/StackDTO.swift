@objc
public enum StackDirection: Int {
    case horizontal
    case vertical
    
    var axis: UILayoutConstraintAxis {
        switch self {
        case .horizontal:
            return .horizontal
        case .vertical:
            return .vertical
        }
    }
}

@objc
public enum StackAligment: Int {
    case fill
    case top
    case center
    case bottom
    case firstBaseline
    case leading
    case trailing
    
    var alignment: UIStackViewAlignment {
        switch self {
        case .fill:
            return .fill
        case .top:
            return .top
        case .center:
            return .center
        case .leading:
            return .leading
        case .trailing:
            return .trailing
        case .bottom:
            return .bottom
        case .firstBaseline:
            return .firstBaseline
        }
    }
}

@objc
public enum StackDistribution: Int {
    case fill
    case fillEqually
    case fillProportionally
    case equalSpacing
    case equalCentering
    
    var distribution: UIStackViewDistribution {
        switch self {
        case .fill:
            return .fill
        case .fillEqually:
            return .fillEqually
        case .fillProportionally:
            return .fillProportionally
        case .equalSpacing:
            return .equalSpacing
        case .equalCentering:
            return .equalCentering
        }
    }
}

public class Stack: NSObject {
    let items: [ViewData]
    let direction: StackDirection
    let alignment: StackAligment
    let distribution: StackDistribution
    let spacing: SpacerSize
    
    @objc
    public init(items: [ViewData], direction: StackDirection, alignment: StackAligment, distribution: StackDistribution, spacing: SpacerSize = .none) {
        self.items = items
        self.direction = direction
        self.alignment = alignment
        self.distribution = distribution
        self.spacing = spacing
        super.init()
    }
}

extension Stack: ViewData {
    public func createView() -> UIView {
        let views = items.map { $0.createView() }
        let stackView = StackView(arrangedSubviews: views)
        stackView.distribution = distribution.distribution
        stackView.axis = direction.axis
        stackView.alignment = alignment.alignment
        stackView.spacing = spacing.floatValue
        return stackView
    }
    
    public func canReuse(view: UIView) -> Bool {
        return view is StackView
    }
    
    public func setupView(view: UIView) {
        guard let stackView = view as? StackView else {
            return
        }
        stackView.distribution = distribution.distribution
        stackView.axis = direction.axis
        stackView.alignment = alignment.alignment
        stackView.spacing = spacing.floatValue
        
        let currentSubviews = stackView.arrangedSubviews
        var reusedSubviews = [UIView]()
        
        for (indexOfItem, item) in items.enumerated() {
            var reused = false
            
            for (indexOfSubview, subview) in currentSubviews.enumerated() {
                if item.canReuse(view: subview) && !reusedSubviews.contains(subview) {
                    item.setupView(view: subview)
                    subview.isHidden = false
                    reused = true
                    reusedSubviews.append(subview)
                    
                    if indexOfItem != indexOfSubview {
                        stackView.removeArrangedSubview(subview)
                        subview.removeFromSuperview()
                        stackView.insertArrangedSubview(subview, at: indexOfItem)
                    }
                    
                    break
                }
            }
            
            if !reused {
                stackView.insertArrangedSubview(item.createView(), at: indexOfItem)
            }
        }
        
        for subview in currentSubviews {
            if !reusedSubviews.contains(subview) {
                stackView.removeArrangedSubview(subview)
                subview.removeFromSuperview()
            }
        }
    }
}
