//
//  FLSection.swift
//  Pods
//
//  Created by Igor Postoev on 18.3.25..
//


public struct FLSection<SectionId, ItemId> {
    
    let sectionItem: FLSectionItem<SectionId>
    let sectionAssembly: any FLItemsContainersAssembly<ItemId>
    let cellFactoryAssembly: any FLCellFactoryAssemly<SectionId>
    
    public init(sectionItem: FLSectionItem<SectionId>,
                sectionAssembly: any FLItemsContainersAssembly<ItemId>,
                cellFactoryAssembly: any FLCellFactoryAssemly<SectionId>) {
        self.sectionItem = sectionItem
        self.sectionAssembly = sectionAssembly
        self.cellFactoryAssembly = cellFactoryAssembly
    }
}
