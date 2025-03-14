//
//  FLValuedCellContentConfiguration.swift
//  FlexLayout
//
//  Created by Igor Postoev on 8.2.24..
//

struct FLSingleValueConfiguration {
    
    weak var delegate: FLSingleValueViewDelegate?
    
    let uid: UUID
    let data: FLSingleValueCellData
    let style: FLCellStyle
}
