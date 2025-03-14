//
//  FLViewInteraction.swift
//  FlexLayout
//
//  Created by Igor Postoev on 13.2.24..
//

/// Provides client with view-related actions
public class FLViewInteraction {
    
    private var itemsContainer: FLCellItemsContainer
    
    init(itemsContainer: FLCellItemsContainer) {
        self.itemsContainer = itemsContainer
    }

    public func getCellItems(ids: [UUID]) -> [FLCellItem]? {
        itemsContainer.getItems(ids: ids)
    }
    
    public func update(cellItems: [FLCellItem]) {
        itemsContainer.update(items: cellItems)
    }
    
    public func remove(cellItems: [FLCellItem]) {
        itemsContainer.remove(items: cellItems)
    }
    
    public func append(cellItems: [FLCellItem]) {
        itemsContainer.append(items: cellItems)
    }
}

