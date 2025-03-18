//
//  FLFlexViewAssembly.swift
//  Pods
//
//  Created by Igor Postoev on 18.3.25..
//


public struct FLFlexViewAssembly<ItemId: Hashable>: FLItemsContainersAssembly  {
    
    let itemIds: [ItemId]
    let itemsByIds: [ItemId: any FlexItemsCellType]
    let config: FLFlexItemsConfig
    let style: FLSectionStyle
    let accessKey: String
    
    public init(itemIds: [ItemId],
                itemsByIds: [ItemId: any FlexItemsCellType],
                config: FLFlexItemsConfig,
                style: FLSectionStyle,
                accessKey: String) {
        self.itemIds = itemIds
        self.itemsByIds = itemsByIds
        self.config = config
        self.style = style
        self.accessKey = accessKey
    }
    
    public func build(cellAssembly: FLCellAssemblyType) -> (UIView, any FLCellItemsContainer<ItemId>) {
        let view = FLFlexItemsView(itemIds: itemIds,
                                   itemsbyIds: itemsByIds,
                                   cellAssembly: cellAssembly,
                                   config: config,
                                   style: style,
                                   accessKey: accessKey)
        // View serves as cell items container as well
        return (view, view)
    }
}
