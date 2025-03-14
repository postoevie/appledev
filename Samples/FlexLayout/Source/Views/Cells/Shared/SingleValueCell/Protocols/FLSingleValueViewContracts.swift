//
//  FLSingleValueViewDelegate.swift
//  FlexLayout
//
//  Created by Igor Postoev on 14.2.24..
//

/// Responds to single value content view actions
protocol FLSingleValueViewDelegate: AnyObject {
    
    /// Called when cell's text input finished editing
    /// - Parameters:
    ///   - itemId: Cell item Id
    ///   - value: Value after finish editing
    func valueChanged(itemId: UUID, value: FLValueDataType)
    
    /// Called when cell's validation view tapped
    /// - Parameters:
    ///   - message: message to show
    ///   - view: sender view
    func tappedValidationView(message: String, in view: UIView)
}

protocol FLCellSectionRouterProtocol: AnyObject {
    
    /// Shows popup with message text
    /// - Parameters:
    ///   - text: Info text to show
    ///   - sender: Source view from which popup should be opened
    func showMessageView(text: String?, sender: UIView)
}

