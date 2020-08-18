@objc
public enum DividerBorder: Int {
    case left
    case right
    case top
    case bottom
}

public class VTBorderView: UIView {
    private var borderLayer: CAShapeLayer?
    
    private let leftBorderView = DividerView()
    private let rightBorderView = DividerView()
    private let bottomBorderView = DividerView()
    private let topBorderView = DividerView()
    
    public var borders: [DividerBorder] = [] {
        didSet {
            updateBorderVisibility()
        }
    }
    public var inverseBorders: Bool = false {
        didSet {
            updateBorderVisibility()
        }
    }
    
    // MARK: - Initializers
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        embedAtTop(view: topBorderView, inContainerView: self)
        embedAtBottom(view: bottomBorderView, inContainerView: self)
        embedToLeft(view: leftBorderView, inContainerView: self)
        embedToRight(view: rightBorderView, inContainerView: self)
        
        topBorderView.isHidden = true
        topBorderView.orientation = .horizontal
        bottomBorderView.isHidden = true
        bottomBorderView.orientation = .horizontal
        leftBorderView.isHidden = true
        leftBorderView.orientation = .vertical
        rightBorderView.isHidden = true
        rightBorderView.orientation = .vertical
    }
    
    private func updateBorderVisibility() {
        topBorderView.isHidden = !borders.contains(.top)
        bottomBorderView.isHidden = !borders.contains(.bottom)
        leftBorderView.isHidden = !borders.contains(.left)
        rightBorderView.isHidden = !borders.contains(.right)
        
        topBorderView.inverse = inverseBorders
        bottomBorderView.inverse = inverseBorders
        leftBorderView.inverse = inverseBorders
        rightBorderView.inverse = inverseBorders
    }
    
    // MARK: - Border configuration for Obj-c

    @objc
    public var leftBorder: Bool {
        get {
            return borders.contains(.left)
        }
        set {
            var newBorders = borders
            if !borders.contains(.left) && newValue {
                newBorders.append(.left)
            }
            if borders.contains(.left) && !newValue {
                newBorders = newBorders.filter({ $0 != .left })
            }
            borders = newBorders
        }
    }

    @objc
    public var rightBorder: Bool {
        get {
            return borders.contains(.right)
        }
        set {
            var newBorders = borders
            if !borders.contains(.right) && newValue {
                newBorders.append(.right)
            }
            if borders.contains(.right) && !newValue {
                newBorders = newBorders.filter({ $0 != .right })
            }
            borders = newBorders
        }
    }

    @objc
    public var topBorder: Bool {
        get {
            return borders.contains(.top)
        }
        set {
            var newBorders = borders
            if !borders.contains(.top) && newValue {
                newBorders.append(.top)
            }
            if borders.contains(.top) && !newValue {
                newBorders = newBorders.filter({ $0 != .top })
            }
            borders = newBorders
        }
    }
    
    @objc
    public var bottomBorder: Bool {
        get {
            return borders.contains(.bottom)
        }
        set {
            var newBorders = borders
            if !borders.contains(.bottom) && newValue {
                newBorders.append(.bottom)
            }
            if borders.contains(.bottom) && !newValue {
                newBorders = newBorders.filter({ $0 != .bottom })
            }
            borders = newBorders
        }
    }
}
