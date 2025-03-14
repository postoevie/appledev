//
//  MealModel.swift
//  Pardus
//
//  Created by Igor Postoev on 27.5.24..
//

// swiftlint:disable all

import CoreData
struct MealModel: EntityModelType, Identifiable {
    
    static private(set) var mapping: EntityModelMappingType = MealModelMapping()
    
    let id: UUID
    let date: Date
    let dishes: [DishModel]
}

private struct MealModelMapping: EntityModelMappingType {
    
    func createObject(context: NSManagedObjectContext, model: EntityModelType) throws -> EntityModelType {
        guard let model = model as? MealModel else {
            throw NSError()
        }
        let entity = Meal(context: context)
        entity.id = model.id
        try fill(managedObject: entity, with: model)
        return try createModel(managedObject: entity)
    }
    
    func createModel(managedObject: NSManagedObject) throws -> EntityModelType {
        throw NSError()
    }
    
    func fill(managedObject: NSManagedObject, with model: EntityModelType) throws {
        guard let entity = managedObject as? Meal,
              let model = model as? MealModel,
              managedObject.managedObjectContext != nil else {
            throw NSError()
        }
        entity.date = model.date
    }
    
    func getMOName() throws -> String {
        guard let name = Meal.entity().name else {
            throw NSError()
        }
        return name
    }
}
