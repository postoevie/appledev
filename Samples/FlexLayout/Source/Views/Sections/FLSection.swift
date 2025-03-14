//
//  FLSection.swift
//  FlexLayout
//
//  Created by Igor Postoev on 14.2.24..
//

public struct FLSection {
    
    let sectionItem: FLSectionItem
    let type: FLSectionType
    let cellItems: [FLCellItem]
    
    public init(sectionItem: FLSectionItem,
                type: FLSectionType,
                cellItems: [FLCellItem]) {
        self.sectionItem = sectionItem
        self.type = type
        self.cellItems = cellItems
    }
}
