//
//  FLSectionStyle.swift
//  FlexLayout
//
//  Created by Igor Postoev on 29.2.24..
//

/// Style of section view
public struct FLSectionStyle: Equatable {
    
    public let bodyBackgroundColor: UIColor
    
    public init(bodyBackgroundColor: UIColor = .clear) {
        self.bodyBackgroundColor = bodyBackgroundColor
    }
}
