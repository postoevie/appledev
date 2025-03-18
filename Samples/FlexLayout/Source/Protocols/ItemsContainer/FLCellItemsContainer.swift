//
//  FLCellItemsContainer.swift
//  FlexLayout
//
//  Created by Igor Postoev on 14.2.24..
//

public protocol FLCellItemType {
    
    associatedtype Id: Hashable
    
    var uid: Id { get set }
}

/// Contains cell items. Reads  and modifies them
public protocol FLCellItemsContainer<ItemId> {
    
    associatedtype ItemId
    
    /// Returns cell  items according to it's ids
    /// - Parameter id: Items' ids
    /// - Returns: Configuration items
    func getItems(ids: [ItemId]) -> [any FLCellItemType]?
    
    /// Update cell item state
    /// - Parameter items: Items to update
    func update(items: [(uid: ItemId, item: any FLCellItemType)])
    
    /// Remove cell items
    /// - Parameter items: Items to remove
    func remove(items: [(uid: ItemId, item: any FLCellItemType)])
    
    /// Append new cell items
    /// - Parameter items: Items to append
    func append(items: [(uid: ItemId, item: any FLCellItemType)])
}
