//
//  FLSectionData.swift
//  FlexLayout
//
//  Created by Igor Postoev on 14.2.24..
//

/// Data for view of section
public struct FLSectionData {
    
    public let title: String?
    public let accessKey: String
    
    public init(title: String? = nil,
                accessKey: String? = nil) {
        self.title = title
        self.accessKey = accessKey ?? "data"
    }
}
