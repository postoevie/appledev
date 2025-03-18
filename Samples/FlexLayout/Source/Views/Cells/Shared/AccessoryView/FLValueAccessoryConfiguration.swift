//
//  Untitled.swift
//  Pods
//
//  Created by Igor Postoev on 14.3.25..
//

struct FLValueAccessoryConfiguration<Delegate: FLSingleValueViewDelegate> {
    
    weak var delegate: Delegate?
    let itemId: Delegate.ItemId
    let validationText: String?
    let validationIconColor: UIColor
}
