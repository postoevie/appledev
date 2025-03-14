//
//  FLCellItem.swift
//  FlexLayout
//
//  Created by Igor Postoev on 6.2.24..
//

/// Configuration item for cell view
public struct FLCellItem: Hashable {
    
    public let sectionId: UUID
    public let uid: UUID
    public var data: FLCellData
    public var style: FLCellStyle
    
    public init(sectionId: UUID, 
                uid: UUID,
                data: FLCellData,
                style: FLCellStyle) {
        self.sectionId = sectionId
        self.uid = uid
        self.data = data
        self.style = style
    }
    
    public static func == (lhs: FLCellItem, rhs: FLCellItem) -> Bool {
        lhs.uid == rhs.uid
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(uid)
    }
}
