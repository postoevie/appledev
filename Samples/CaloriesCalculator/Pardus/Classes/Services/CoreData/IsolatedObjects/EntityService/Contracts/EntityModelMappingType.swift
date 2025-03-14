//
//  EntityModelMappingType.swift
//  Pardus
//
//  Created by Igor Postoev on 26.5.24..
//

import CoreData

/// Mapper between Managed Object and its associated Model
protocol EntityModelMappingType {
    
    /// Creates new Managed object with data in associated model
    func createObject(context: NSManagedObjectContext, model: EntityModelType) throws -> EntityModelType
    
    /// Maps Managed Object to its Model struct
    func createModel(managedObject: NSManagedObject) throws -> EntityModelType
    
    /// Copies attributes and relations from model to managed objects
    func fill(managedObject: NSManagedObject, with model: EntityModelType) throws
    
    /// Returns Managed object scheme name
    func getMOName() throws -> String
}
