//
//  FLCellData.swift
//  FlexLayout
//
//  Created by Igor Postoev on 14.2.24..
//

/// Cell data according to it's type
public enum FLCellData: Equatable {
    
    /// Type representing single valued cell with title
    case titledSingleValue(data: FLSingleValueCellData, title: String, validationText: String?)
    
    /// Type representing cell with no data
    case empty
}

extension FLCellData {
    
    func getSingleValueData() -> FLSingleValueCellData? {
        switch self {
        case .titledSingleValue(let data, _, _):
            return data
        default:
            return nil
        }
    }
}

