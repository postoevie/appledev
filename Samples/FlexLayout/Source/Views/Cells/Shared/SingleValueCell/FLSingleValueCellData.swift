//
//  FLSingleValueItem.swift
//  FlexLayout
//
//  Created by Igor Postoev on 12.2.24..
//

public struct FLSingleValueCellData: Equatable {
    
    public var value: FLValueDataType
    public let layout: FLValueLayoutType
    public let readonly: Bool
    public let accessKey: String
    
    public init(value: FLValueDataType,
                layout: FLValueLayoutType,
                readonly: Bool = false,
                accessKey: String = "") {
        self.value = value
        self.readonly = readonly
        self.layout = layout
        self.accessKey = accessKey
    }
}

public enum FLValueDataType: Equatable {
    
    case text(String?)
    case boolean(Bool)
    case empty
    
    func isSameType(value: FLValueDataType) -> Bool {
        switch (self, value) {
        case (.text, .text), (.boolean, .boolean):
            return true
        case (.empty, .empty):
            return true
        default:
            return false
        }
    }
}

public enum FLValueLayoutType {
    
    case text
    case number
    case boolean
    case empty
}
