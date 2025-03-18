//
//  FLUtils.swift
//  FlexLayout
//
//  Created by Igor Postoev on 6.2.24..
//

class NiblessViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable,
               message: "Loading this controller from a nib is unsupported")
    required init?(coder: NSCoder) {
        fatalError("Loading this controller from a nib is unsupported")
    }
}

class NiblessView: UIView {
    
    // MARK: - Methods

    init() {
        super.init(frame: .zero)
    }

    @available(*, unavailable,
               message: "Loading this view from a nib is unsupported")
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Loading this view from a nib is unsupported")
    }
}


/// Integer that is strictly greater than zero (x > 0)
@propertyWrapper public struct GreaterZeroInt {
    
    public var wrappedValue: Int {
        didSet {
            wrappedValue = max(1, wrappedValue)
        }
    }

    public init(wrappedValue: Int) {
        self.wrappedValue = max(1, wrappedValue)
    }
}

/// Float which interval is [0...1]
@propertyWrapper public struct Ratio {
    
    public var wrappedValue: Float {
        didSet {
            wrappedValue = max(0, wrappedValue)
            wrappedValue = min(1, wrappedValue)
        }
    }

    public init(wrappedValue: Float) {
        self.wrappedValue = max(0, wrappedValue)
        self.wrappedValue = min(1, self.wrappedValue)
    }
}

extension UITextField {
    
    func selectAll() {
        selectedTextRange = textRange(from: endOfDocument, to: beginningOfDocument)
    }
}
