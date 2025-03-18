//
//  FLSingleValueViewDelegate.swift
//  FlexLayout
//
//  Created by Igor Postoev on 14.2.24..
//

/// Alows the module to create default values of conofming type
public protocol Initializable {
    
    init()
}

/// Responds to single value content view actions
protocol FLSingleValueViewDelegate: AnyObject {
    
    associatedtype ItemId: Initializable
    
    /// Called when cell's text input finished editing
    /// - Parameters:
    ///   - itemId: Cell item Id
    ///   - value: Value after finish editing
    func valueChanged(itemId: ItemId, value: FLValueDataType)
    
    /// Called when cell's validation view tapped
    /// - Parameters:
    ///   - message: message to show
    ///   - view: sender view
    func tappedValidationView(message: String, in view: UIView)
}

public protocol FLCellSectionRouterProtocol: AnyObject {
    
    /// Shows popup with message text
    /// - Parameters:
    ///   - text: Info text to show
    ///   - sender: Source view from which popup should be opened
    func showMessageView(text: String?, sender: UIView)
}

