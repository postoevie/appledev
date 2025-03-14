//
//  MealIngridientEditInteractor.swift
//  Pardus
//
//  Created by Igor Postoev on 2.6.24.
//
//

import Foundation
import CoreData
import SwiftUI

final class MealIngridientEditInteractor: MealIngridientEditInteractorProtocol {
    
    var ingridientId: UUID?
    
    private var mealIngridient: MealIngridient?
    private let coreDataService: CoreDataServiceType
    
    init(coreDataService: CoreDataServiceType, ingridientId: UUID?) {
        self.coreDataService = coreDataService
        self.ingridientId = ingridientId
    }
    
    func loadIngridient() async throws {
        if let ingridientId {
            try await coreDataService.perform {
                self.mealIngridient = try $0.fetchOne(type: MealIngridient.self, predicate: .idIn(uids: [ingridientId]))
            }
            return
        }
        try await coreDataService.perform {
            let newIngridient = try $0.create(type: MealIngridient.self, id: UUID())
            self.mealIngridient = newIngridient
            self.ingridientId = newIngridient.id
        }
    }
    
    var data: MealIngridientEditData? {
        guard let mealIngridient else {
            return nil
        }
        return MealIngridientEditData(name: mealIngridient.name,
                                      weight: mealIngridient.weight,
                                      caloriesPer100: mealIngridient.caloriesPer100,
                                      proteinsPer100: mealIngridient.proteinsPer100,
                                      fatsPer100: mealIngridient.fatsPer100,
                                      carbsPer100: mealIngridient.carbsPer100,
                                      calories: mealIngridient.calories,
                                      proteins: mealIngridient.proteins,
                                      fats: mealIngridient.fats,
                                      carbohydrates: mealIngridient.carbs)
    }
    
    func setName(_ name: String) async {
        await coreDataService.perform { _ in
            self.mealIngridient?.name = name
        }
    }
    
    func setWeight(_ weight: Double) async {
        await coreDataService.perform { _ in
            self.mealIngridient?.weight = weight
        }
    }
    
    func setCalories(_ calories: Double) async {
        await coreDataService.perform { _ in
            self.mealIngridient?.caloriesPer100 = calories
        }
    }
    
    func setProteins(_ proteins: Double) async {
        await coreDataService.perform { _ in
            self.mealIngridient?.proteinsPer100 = proteins
        }
    }
    
    func setFats(_ fats: Double) async {
        await coreDataService.perform { _ in
            self.mealIngridient?.fatsPer100 = fats
        }
    }
    
    func setCarbs(_ carbs: Double) async {
        await coreDataService.perform { _ in
            self.mealIngridient?.carbsPer100 = carbs
        }
    }
    
    func save() async throws {
        try await coreDataService.perform {
            try $0.persistChanges()
        }
    }
}
