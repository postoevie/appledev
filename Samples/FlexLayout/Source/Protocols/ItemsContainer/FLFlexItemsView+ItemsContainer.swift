//
//  FLCellItemsContainer+ItemsContainer.swift
//  FlexLayout
//
//  Created by Igor Postoev on 21.2.24..
//

extension FLFlexItemsView: FLCellItemsContainer {
    
    func getItems(ids: [UUID]) -> [FLCellItem]? {
        itemsByIds.compactMap { ids.contains($0.key) ? $0.value : nil }
    }
    
    func update(items: [FLCellItem]) {
        var idsToReconfigure = [UUID]()
        for item in items {
            itemsByIds[item.uid] = item
            idsToReconfigure.append(item.uid)
        }
        var snapshot = dataSource.snapshot()
        snapshot.reconfigureItems(idsToReconfigure)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func remove(items: [FLCellItem]) {
        items.forEach { item in
            itemsByIds[item.uid] = nil
        }
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems(items.compactMap { $0.uid })
        dataSource.apply(snapshot)
    }
    
    func append(items: [FLCellItem]) {
        items.forEach { item in
            itemsByIds[item.uid] = item
        }
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems(items.compactMap { $0.uid })
        dataSource.apply(snapshot)
    }
}
