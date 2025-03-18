//
//  FLCellItem.swift
//  FlexLayout
//
//  Created by Igor Postoev on 6.2.24..
//

/// Configuration item for cell view
public struct FLCellItem<Id: Hashable> {
    
    public var uid: Id
    public var data: FLCellData
    public var style: FLCellStyle
    
    public init(uid: Id,
                data: FLCellData,
                style: FLCellStyle) {
        self.uid = uid
        self.data = data
        self.style = style
    }
}
