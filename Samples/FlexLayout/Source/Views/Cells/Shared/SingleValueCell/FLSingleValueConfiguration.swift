//
//  FLValuedCellContentConfiguration.swift
//  FlexLayout
//
//  Created by Igor Postoev on 8.2.24..
//

struct FLSingleValueConfiguration<Delegate: FLSingleValueViewDelegate> {
    
    weak var delegate: Delegate?
    
    let uid: Delegate.ItemId
    let data: FLSingleValueCellData
    let style: FLCellStyle
}
