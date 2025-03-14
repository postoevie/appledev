//
//  MealsDataService.swift
//  Pardus
//
//  Created by Igor Postoev on 19.5.24..
//

// swiftlint:disable all

import CoreData

class CoreDataEntityService {
    
    private let context: NSManagedObjectContext
    private let cachesMapping: [String: any EntityCacheType]
    private let restoration: CoreDataRestorationStoreType?
    
    init(context: NSManagedObjectContext,
         caches: [String: any EntityCacheType] = [:],
         restoration: CoreDataRestorationStoreType? = nil) {
        self.context = context
        self.cachesMapping = caches
        self.restoration = restoration
    }
}

extension CoreDataEntityService: EntityModelServiceType {
    
    func create<EntityModel: EntityModelType>(model: EntityModel) async throws -> EntityModel {
        try await context.perform {
            guard let object = try EntityModel.mapping.createObject(context: self.context, model: model) as? EntityModel else {
                throw NSError()
            }
            return object
        }
    }
    
    private func fetch(entityName: String, predicate: NSPredicate?, sortParams: (field: String, ascending: Bool)?) throws -> [IdentifiedManagedObject] {
        let request = NSFetchRequest<IdentifiedManagedObject>(entityName: entityName)
        request.predicate = predicate
        if let sortParams {
            request.sortDescriptors = [NSSortDescriptor(key: sortParams.field, ascending: sortParams.ascending)]
        }
        return try self.context.fetch(request)
    }
    
    func fetch<EntityModel: EntityModelType>(entityIds: [UUID]) async throws -> [EntityModel] {
        let asyncSequence = entityIds.map { entityId in
            let managedObjects = try await self.context.perform {
                try self.fetch(entityName: try EntityModel.mapping.getMOName(),
                               predicate: NSPredicate.idIn(uids: [entityId]),
                               sortParams: nil)
            }
            guard let managedObject = managedObjects.first,
                  let model = try EntityModel.mapping.createModel(managedObject: managedObject) as? EntityModel else {
                throw NSError()
            }
            return model
        }
        var models: [EntityModel] = []
        for try await model in asyncSequence {
            models.append(model)
        }
        return models
    }
    
    func fetch<EntityModel: EntityModelType>(predicate: NSPredicate?, sortParams: (field: String, ascending: Bool)?) async throws -> [EntityModel] {
        let managedObjects = try await context.perform {
            try self.fetch(entityName: EntityModel.mapping.getMOName(), predicate: predicate, sortParams: sortParams)
        }
        return try managedObjects.map {
            guard let model = try EntityModel.mapping.createModel(managedObject: $0) as? EntityModel else {
                throw NSError()
            }
            return model
        }
    }
    
    func update<EntityModel: EntityModelType>(models: [EntityModel]) async throws {
        let predicate = NSPredicate.idIn(uids: models.map { $0.id })
        try await context.perform {
            let managedObjects = try self.fetch(entityName: EntityModel.mapping.getMOName(), predicate: predicate, sortParams: nil)
            try managedObjects.forEach { managedObject in
                guard let model = models.first(where: { model in managedObject.id == model.id }) else {
                    return
                }
                try EntityModel.mapping.fill(managedObject: managedObject, with: model)
            }
        }
    }

    func save() async throws {
        try await context.perform {
            try self.context.persist()
        }
    }
    
    func delete<EntityModel: EntityModelType>(models: [EntityModel]) async throws {
        let predicate = NSPredicate.idIn(uids: models.map { $0.id })
        try await context.perform {
            let managedObjects = try self.fetch(entityName: EntityModel.mapping.getMOName(), predicate: predicate, sortParams: nil)
            managedObjects.forEach {
                self.context.delete($0)
            }
        }
    }
}

extension CoreDataEntityService: EntityCacheServiceType {
    
    func cache<EntityModel>(predicate: NSPredicate, modelType: EntityModel.Type) async throws {
        try await getCache(EntityModel.self).cache(predicate: predicate)
    }
    
    func fetchCached<EntityModel: EntityModelType>(predicate: NSPredicate?) throws -> [EntityModel] {
        guard let models = try getCache(EntityModel.self).pull(predicate: predicate) as? [EntityModel] else {
            throw NSError()
        }
        return models
    }
    
    func cache<EntityModel: EntityModelType>(models: [EntityModel]) async throws {
        try await getCache(EntityModel.self).cache(models: models)
    }
    
    func uncache<EntityModel: EntityModelType>(models: [EntityModel]) throws {
        try getCache(EntityModel.self).uncache(models: models)
    }
    
    func updateCached<EntityModel: EntityModelType>(models: [EntityModel]) throws {
        try getCache(EntityModel.self).update(models: models)
    }
    
    private func getCache<EntityModel>(_ modelType: EntityModel.Type) throws -> any EntityCacheType {
        let key = ObjectKey(modelType, name: nil).key
        guard let cache = cachesMapping[key] else {
            throw NSError()
        }
        return cache
    }
}
