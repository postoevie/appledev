//
//  FLSectionItem.swift
//  FlexLayout
//
//  Created by Igor Postoev on 29.2.24..
//

/// Configuration item for section view
public struct FLSectionItem<Id> {
    
    public let uid: Id
    public let data: FLSectionData
    public let style: FLSectionStyle
    
    public init(uid: Id, data: FLSectionData, style: FLSectionStyle) {
        self.uid = uid
        self.data = data
        self.style = style
    }
}
