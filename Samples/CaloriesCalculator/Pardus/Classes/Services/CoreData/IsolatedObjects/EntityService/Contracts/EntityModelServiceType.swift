//
//  EntityServiceType.swift
//  Pardus
//
//  Created by Igor Postoev on 23.5.24.
//	
//

// swiftlint:disable all

import Foundation

protocol EntityModelServiceType {
 
    /// CRUD Operations passing EntityModelType to make an peratioin with associated managed object
    func create<T: EntityModelType>(model: T) async throws -> T
    func fetch<T: EntityModelType>(entityIds: [UUID]) async throws -> [T]
    func fetch<T: EntityModelType>(predicate: NSPredicate?, sortParams: (field: String, ascending: Bool)?) async throws -> [T]
    func update<T: EntityModelType>(models: [T]) async throws
    func delete<T: EntityModelType>(models: [T]) async throws
    
    /// Persists data
    func save() async throws
}

extension EntityModelServiceType {
    
    func fetch<EntityModel: EntityModelType>(predicate: NSPredicate?, sortParams: (field: String, ascending: Bool)? = nil) async throws -> [EntityModel] {
       try await fetch(predicate: predicate, sortParams: sortParams)
    }
}
