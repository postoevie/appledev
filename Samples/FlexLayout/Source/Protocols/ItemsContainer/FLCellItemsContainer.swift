//
//  FLCellItemsContainer.swift
//  FlexLayout
//
//  Created by Igor Postoev on 14.2.24..
//

/// Contains cell items. Reads  and modifies them
protocol FLCellItemsContainer: AnyObject {
    
    /// Returns cell  items according to it's ids
    /// - Parameter id: Items' ids
    /// - Returns: Configuration items
    func getItems(ids: [UUID]) -> [FLCellItem]?
    
    /// Update cell item state
    /// - Parameter items: Items to update
    func update(items: [FLCellItem])
    
    /// Remove cell items
    /// - Parameter items: Items to remove
    func remove(items: [FLCellItem])
    
    /// Append new cell items
    /// - Parameter items: Items to append
    func append(items: [FLCellItem])
}
