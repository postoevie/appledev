//
//  EntityModelType.swift
//  Pardus
//
//  Created by Igor Postoev on 27.5.24..
//

import Foundation

/// Model which client use to manage ManagedObjects hidden by Entity Service
protocol EntityModelType {
    
    /// Unique id from associated Managed Object
    var id: UUID { get }
    
    /// Maps Model to ManagedObject and vise versa
    static var mapping: EntityModelMappingType { get }
}
