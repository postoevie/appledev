//
//  FLFlexItemsConfig.swift
//  FlexLayout
//
//  Created by Igor Postoev on 16.2.24..
//

public struct RatioValue {
    
    @Ratio
    public var value: Float
    
    public init(value: Float) {
        self.value = value
    }
}

public struct FLFlexItemsConfig {
    
    let flexRatios: [RatioValue]
    let rowHeight: CGFloat
    
    public init(ratios: [RatioValue],
                rowHeight: CGFloat) {
        self.flexRatios = ratios
        self.rowHeight = rowHeight
    }
}
