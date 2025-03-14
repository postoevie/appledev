//
//  DishGroupModel.swift
//  Pardus
//
//  Created by Igor Postoev on 1.6.24..
//

// swiftlint:disable all

import CoreData

struct DishCategoryModel: EntityModelType {
    
    private(set) static var mapping: EntityModelMappingType = DishCategoryModelMapping()
    
    let id: UUID
    let name: String
    let colorHex: String
    
    let objectId: NSManagedObjectID?
}

private struct DishCategoryModelMapping: EntityModelMappingType {
    
    func createObject(context: NSManagedObjectContext, model: EntityModelType) throws -> EntityModelType {
        guard let model = model as? DishCategoryModel else {
            throw NSError()
        }
        let entity = DishCategory(context: context)
        entity.id = model.id
        entity.colorHex = model.colorHex
        try fill(managedObject: entity, with: model)
        return try createModel(managedObject: entity)
    }
    
    func createModel(managedObject: NSManagedObject) throws -> EntityModelType {
        guard let context = managedObject.managedObjectContext,
              let entity = managedObject as? DishCategory else {
            throw NSError()
        }
        var model: DishCategoryModel?
        context.performAndWait {
            model = DishCategoryModel(id: entity.id,
                                      name: entity.name,
                                      colorHex: entity.colorHex ?? "",
                                      objectId: entity.objectID)
        }
        guard let model else {
            throw NSError()
        }
        return model
    }
    
    func fill(managedObject: NSManagedObject, with model: EntityModelType) throws {
        guard let entity = managedObject as? DishCategory,
              let model = model as? DishCategoryModel else {
            throw NSError()
        }
        entity.name = model.name
        entity.colorHex = model.colorHex
    }
    
    func getMOName() throws -> String {
        guard let name = DishCategory.entity().name else {
            throw NSError()
        }
        return name
    }
}
