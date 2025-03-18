//
//  FLCellStyle.swift
//  FlexLayout
//
//  Created by Igor Postoev on 12.2.24..
//

public struct FLTextAttributes: Equatable {
    let font: UIFont
    let color: UIColor
    
    public init(font: UIFont = .systemFont(ofSize: 14),
                color: UIColor = .black) {
        self.font = font
        self.color = color
    }
}

/// Style of cell
public struct FLCellStyle: Equatable {
    
    public let titleTextAttributes: FLTextAttributes
    public let valueTextAttributes: FLTextAttributes
    public let backgroundColor: UIColor
    public let validationColor: UIColor
    
    public init(titleTextAttributes: FLTextAttributes = FLTextAttributes(),
                valueTextAttributes: FLTextAttributes = FLTextAttributes(),
                backgroundColor: UIColor = .clear,
                validationColor: UIColor = .clear) {
        self.titleTextAttributes = titleTextAttributes
        self.valueTextAttributes = valueTextAttributes
        self.backgroundColor = backgroundColor
        self.validationColor = validationColor
    }
}
