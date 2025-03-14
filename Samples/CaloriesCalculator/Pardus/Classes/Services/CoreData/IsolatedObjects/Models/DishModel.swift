//
//  DishModel.swift
//  Pardus
//
//  Created by Igor Postoev on 31.5.24..
//

// swiftlint:disable all

import CoreData

struct DishModel: EntityModelType, Identifiable {
    
    private(set) static var mapping: EntityModelMappingType = DishModelMapping()
    
    let id: UUID
    let name: String
    let category: DishCategoryModel?
    let calories: Double
    let proteins: Double
    let fats: Double
    let carbohydrates: Double
    
    let objectId: NSManagedObjectID?
}

private struct DishModelMapping: EntityModelMappingType {
    
    func createObject(context: NSManagedObjectContext, model: EntityModelType) throws -> EntityModelType {
        guard let model = model as? DishModel else {
            throw NSError()
        }
        let entity = Dish(context: context)
        entity.id = model.id
        try fill(managedObject: entity, with: model)
        return try createModel(managedObject: entity)
    }
    
    func createModel(managedObject: NSManagedObject) throws -> EntityModelType {
        throw NSError()
    }
    
    func fill(managedObject: NSManagedObject, with model: EntityModelType) throws {
        guard let entity = managedObject as? Dish,
              let model = model as? DishModel,
              let context = managedObject.managedObjectContext else {
            throw NSError()
        }
        entity.name = model.name
        entity.category = if let categoryId = model.category?.objectId {
            context.object(with: categoryId) as? DishCategory
        } else {
            nil
        }
    }
    
    func getMOName() throws -> String {
        guard let name = Dish.entity().name else {
            throw NSError()
        }
        return name
    }
}

