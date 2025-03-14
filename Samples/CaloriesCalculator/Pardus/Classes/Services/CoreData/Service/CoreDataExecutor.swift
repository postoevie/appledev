//
//  CoreDataExecutor.swift
//  Pardus
//
//  Created by Igor Postoev on 12.8.24..
//

import CoreData

struct SortParams {
    
    let fieldName: String
    let ascending: Bool
}

struct CoreDataExecutor: CoreDataExecutorType {

    let context: NSManagedObjectContext
    
    @discardableResult
    func create<Object>(type: Object.Type, id: UUID) throws -> Object where Object: IdentifiedManagedObject {
        let object = Object(context: context)
        object.id = id
        object.createdAt = Date()
        return object
    }
    
    func fetchMany<Object>(type: Object.Type,
                           predicate: NSPredicate?) throws -> [Object] where Object: NSManagedObject {
        try fetchMany(type: type, predicate: predicate, sortBy: nil)
    }
    
    func fetchMany<Object>(type: Object.Type,
                           predicate: NSPredicate?,
                           sortBy sortData: SortParams?) throws -> [Object] where Object: NSManagedObject {
        let request = NSFetchRequest<Object>(entityName: String(describing: Object.self))
        request.predicate = predicate
        if let sortData {
            request.sortDescriptors = [NSSortDescriptor(key: sortData.fieldName,
                                                        ascending: sortData.ascending,
                                                        selector: nil)]
        }
        return try context.fetch(request)
    }
    
    func fetchOne<Object>(type: Object.Type, predicate: NSPredicate?) throws -> Object? where Object: NSManagedObject {
        let request = NSFetchRequest<Object>(entityName: String(describing: Object.self))
        request.fetchLimit = 1
        request.predicate = predicate
        return (try context.fetch(request)).first
    }
    
    func fetch(objectID: NSManagedObjectID) throws -> NSManagedObject {
        try context.existingObject(with: objectID)
    }
    
    func count<Object>(type: Object.Type, predicate: NSPredicate?) throws -> Int where Object: NSManagedObject {
        let request = NSFetchRequest<Object>(entityName: String(describing: Object.self))
        request.predicate = predicate
        return try context.count(for: request)
    }
    
    func delete(objectId: NSManagedObjectID) throws {
        let entityInContext = try context.existingObject(with: objectId)
        context.delete(entityInContext)
    }
    
    func persistChanges() throws {
        try context.persist()
    }
}
