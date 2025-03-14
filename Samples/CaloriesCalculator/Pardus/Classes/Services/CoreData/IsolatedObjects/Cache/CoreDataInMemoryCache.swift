//
//  CoreDataInMemoryCache.swift
//  Pardus
//
//  Created by Igor Postoev on 23.5.24..
//

import CoreData

class CoreDataInMemoryCache: EntityCacheType {
    
    let context: NSManagedObjectContext
    let mapping: EntityModelMappingType
    
    private var entitiesDict: [UUID: IdentifiedManagedObject] = [:]
    
    private var unsortedIds: [UUID] {
        Array(entitiesDict.keys)
    }
    
    private var unsortedEntities: [IdentifiedManagedObject] {
        Array(entitiesDict.values)
    }
    
    init(context: NSManagedObjectContext, mapping: EntityModelMappingType) {
        self.context = context
        self.mapping = mapping
    }
    
    func pull(predicate: NSPredicate?) throws -> [EntityModelType] {
        if let predicate {
            try unsortedEntities
                .filter {
                    predicate.evaluate(with: $0)
                }.map {
                    return try mapping.createModel(managedObject: $0)
                }
        } else {
            try unsortedEntities.map {
                return try mapping.createModel(managedObject: $0)
            }
        }
    }
    
    func cache(predicate: NSPredicate?) async throws {
        let request = NSFetchRequest<IdentifiedManagedObject>(entityName: try mapping.getMOName())
        let excludePredicate = NSPredicate(format: "id not in \(unsortedIds)")
        request.predicate = if let predicate {
            NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, excludePredicate])
        } else {
            excludePredicate
        }
        try await context.perform {
            let fetchedEntities = try self.context.fetch(request)
            let uniqueEntities = Set(self.unsortedEntities + fetchedEntities)
            self.entitiesDict = Dictionary(uniqueKeysWithValues: uniqueEntities.map { ($0.id, $0) })
        }
    }
    
    func cache(models: [EntityModelType]) async throws {
        let mealIdsToFetch = Set(models.map { $0.id }).subtracting(Set(unsortedIds))
        let request = NSFetchRequest<IdentifiedManagedObject>(entityName: try mapping.getMOName())
        request.predicate = NSPredicate.idIn(uids: Array(mealIdsToFetch))
        try await context.perform {
            let fetchedEntities = try self.context.fetch(request)
            let uniqueEntities = Set(self.unsortedEntities + fetchedEntities)
            self.entitiesDict = Dictionary(uniqueKeysWithValues: uniqueEntities.map { ($0.id, $0) })
        }
    }
    
    func uncache(predicate: NSPredicate) {
        entitiesDict = entitiesDict.filter { !predicate.evaluate(with: $1) }
    }
    
    func uncache(models: [EntityModelType]) {
        for model in models {
            entitiesDict[model.id] = nil
        }
    }
    
    func update(models: [EntityModelType]) throws {
        for model in models {
            guard let mealMO = entitiesDict[model.id] else {
                assertionFailure(); continue
            }
            try mapping.fill(managedObject: mealMO, with: model)
        }
    }
}
