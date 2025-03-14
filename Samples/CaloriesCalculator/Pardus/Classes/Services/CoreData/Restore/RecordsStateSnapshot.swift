//
//  RecordsStateSnapshot.swift
//  Pardus
//
//  Created by Igor Postoev on 2.12.24..
//

import Foundation

struct RecordsStateSnapshot: Codable {
    
    let dishCategories: [UUID: DishCategoryState]
    let dishes: [UUID: DishState]
    
    let ingridientCategories: [UUID: IngridientCategoryState]
    let ingridients: [UUID: IngridientState]
}

struct DishState: Codable {
    
    let name: String
    let categoryId: UUID?
    let ingridientIds: Set<UUID>
}

struct DishCategoryState: Codable {
    
    let name: String
}

struct IngridientState: Codable {
    
    let name: String
    let calories: Double
    let proteins: Double
    let fats: Double
    let carbs: Double
    let categoryId: UUID?
}

struct IngridientCategoryState: Codable {
    
    let name: String
}
