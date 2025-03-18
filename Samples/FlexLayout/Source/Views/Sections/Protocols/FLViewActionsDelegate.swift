//
//  FLViewActionsDelegate.swift
//  FlexLayout
//
//  Created by Igor Postoev on 8.2.24..
//

/// Responds to user actions made in  view
public protocol FLViewActionsDelegate<SectionId, ItemId>: AnyObject {
    
    associatedtype SectionId
    associatedtype ItemId
    
    /// Called when current value of input of cell is changed
    /// - Parameters:
    ///   - sectionId: Id of item's section
    ///   - itemId: Cell item id
    ///   - newValue: Value changed to
    func valueOfInputInCellChanged(sectionId: SectionId, itemId: ItemId, newValue: FLValueDataType)
}

