//
//  Untitled.swift
//  Pods
//
//  Created by Igor Postoev on 14.3.25..
//

struct FLValueAccessoryConfiguration {
    
    weak var delegate: FLSingleValueViewDelegate?
    let itemId: UUID
    let validationText: String?
    let validationIconColor: UIColor
}
