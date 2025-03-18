//
//  FLViewInteraction.swift
//  FlexLayout
//
//  Created by Igor Postoev on 13.2.24..
//

/// Provides client with view-related actions
public class FLViewInteraction<ItemId> {
    
    let itemsContainer: any FLCellItemsContainer<ItemId>
    
    init(itemsContainer: any FLCellItemsContainer<ItemId>) {
        self.itemsContainer = itemsContainer
    }

    public func getCellItems(ids: [ItemId]) -> [any FLCellItemType]? {
        itemsContainer.getItems(ids: ids)
    }
    
    public func update(cellItems: [(uid: ItemId, item: any FLCellItemType)]) {
        itemsContainer.update(items: cellItems)
    }
    
    public func remove(cellItems: [(uid: ItemId, item: any FLCellItemType)]) {
        itemsContainer.remove(items: cellItems)
    }
    
    public func append(cellItems: [(uid: ItemId, item: any FLCellItemType)]) {
        itemsContainer.append(items: cellItems)
    }
}

