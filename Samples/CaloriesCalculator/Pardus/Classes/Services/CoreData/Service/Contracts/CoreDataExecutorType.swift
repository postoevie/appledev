//
//  CoreDataExecutorProtocol.swift
//  Pardus
//
//  Created by Igor Postoev on 12.8.24..
//

import CoreData

/// Performs various database operations
protocol CoreDataExecutorType {
    @discardableResult
    func create<Object: IdentifiedManagedObject>(type: Object.Type, id: UUID) throws -> Object
    func fetchMany<Object>(type: Object.Type, predicate: NSPredicate?) throws -> [Object] where Object: NSManagedObject
    func fetchMany<Object>(type: Object.Type,
                           predicate: NSPredicate?,
                           sortBy: SortParams?) throws -> [Object] where Object: NSManagedObject
    func fetchOne<Object>(type: Object.Type, predicate: NSPredicate?) throws -> Object? where Object: NSManagedObject
    func fetch(objectID: NSManagedObjectID) throws -> NSManagedObject
    func count<Object>(type: Object.Type, predicate: NSPredicate?) throws -> Int where Object: NSManagedObject
    func delete(objectId: NSManagedObjectID) throws
    func persistChanges() throws
}
