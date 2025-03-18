//
//  FLCellItemsContainer+ItemsContainer.swift
//  FlexLayout
//
//  Created by Igor Postoev on 21.2.24..
//

extension FLFlexItemsView: FLCellItemsContainer {
    
    func getItems(ids: [ItemId]) -> [any FLCellItemType]? {
        itemsByIds.compactMap { ids.contains($0.key) ? $0.value : nil }
    }
    
    func update(items: [(uid: ItemId, item: any FLCellItemType)]) {
        var idsToReconfigure = [ItemId]()
        for (uid, item) in items {
            itemsByIds[uid] = item
            idsToReconfigure.append(uid)
        }
        var snapshot = dataSource.snapshot()
        snapshot.reconfigureItems(idsToReconfigure)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func remove(items: [(uid: ItemId, item: any FLCellItemType)]) {
        for (uid, _) in items {
            itemsByIds[uid] = nil
        }
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems(items.compactMap { $0.uid })
        dataSource.apply(snapshot)
    }
    
    func append(items: [(uid: ItemId, item: any FLCellItemType)]) {
        for (uid, item) in items {
            itemsByIds[uid] = item
        }
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems(items.compactMap { $0.uid })
        dataSource.apply(snapshot)
    }
}
