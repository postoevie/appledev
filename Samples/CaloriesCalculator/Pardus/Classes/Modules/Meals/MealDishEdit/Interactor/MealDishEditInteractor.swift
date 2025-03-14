//
//  MealEditInteractor.swift
//  Pardus
//
//  Created by Igor Postoev on 18.5.24.
//
//

import Foundation

class MealDishEditInteractor: MealDishEditInteractorProtocol {
    
    var mealDishId: UUID?
    
    private var mealDish: MealDish?
    
    private let coreDataService: CoreDataServiceType
    
    var ingridientsFilter: Predicate? {
        var ingridientIds = [UUID]()
        coreDataService.syncPerform { _ in
            guard let ingridients = self.mealDish?.ingridients else {
                return
            }
            ingridientIds = ingridients.compactMap { $0.ingridient?.id }
        }
        return .idNotIn(uids: ingridientIds)
    }
    
    init(coreDataService: CoreDataServiceType, mealDishId: UUID?) {
        self.coreDataService = coreDataService
        self.mealDishId = mealDishId
    }
    
    func loadInitialMealDish() async throws {
        guard mealDish == nil,
              let mealDishId else {
            return
        }
        try await coreDataService.perform { executor in
            self.mealDish = try executor.fetchOne(type: MealDish.self, predicate: .idIn(uids: [mealDishId]))
        }
    }
    
    func setSelectedIngridients(_ ingridientIds: Set<UUID>) async throws {
        guard let mealDish else {
            return
        }
        try await coreDataService.perform { executor in
            let sortParams = SortParams(fieldName: (\Ingridient.name).fieldName, ascending: true)
            let ingridientsToAdd = try executor.fetchMany(type: Ingridient.self,
                                                          predicate: NSPredicate.idIn(uids: Array(ingridientIds)),
                                                          sortBy: sortParams)
            for ingridient in ingridientsToAdd {
                try self.makeMealIngridient(executor, mealDish: mealDish, ingridient: ingridient)
            }
        }
    }
    
    private func makeMealIngridient(_ executor: CoreDataExecutorType,
                                    mealDish: MealDish,
                                    ingridient: Ingridient) throws {
        let mealIngridient = try executor.create(type: MealIngridient.self, id: UUID())
        mealIngridient.dish = mealDish
        mealIngridient.ingridient = ingridient
        mealIngridient.name = ingridient.name
        mealIngridient.caloriesPer100 = ingridient.calories
        mealIngridient.proteinsPer100 = ingridient.proteins
        mealIngridient.fatsPer100 = ingridient.fats
        mealIngridient.carbsPer100 = ingridient.carbs
    }
    
    func remove(ingridientId: UUID) async throws {
        guard let mealDish else {
            assertionFailure()
            return
        }
        await coreDataService.perform { _ in
            if let ingridientToRemove = mealDish.ingridients[ingridientId] {
                self.mealDish?.ingridients.remove(ingridientToRemove)
            }
        }
    }
    
    func createMealIngridient() async throws -> UUID {
        let ingridientId = UUID()
        try await coreDataService.perform { executor in
            guard let mealDish = self.mealDish else {
                assertionFailure()
                throw MealDishError.noEntity
            }
            let ingridient = try executor.create(type: MealIngridient.self, id: ingridientId)
            ingridient.dish = mealDish
        }
        return ingridientId
    }
    
    func performWithMealDish(action: @escaping (MealDish?) -> Void) async throws {
        await coreDataService.perform { _ in
            action(self.mealDish)
        }
    }
    
    func performWithIngridients(action: @escaping ([MealIngridient]) -> Void) async throws {
        await coreDataService.perform { _ in
            guard let mealDish = self.mealDish else {
                action([])
                return
            }
            let mealDishes = Array(mealDish.ingridients)
            action(self.sorted(mealDishes))
        }
    }
    
    private func sorted(_ mealIngridients: [MealIngridient]) -> [MealIngridient] {
        mealIngridients.sorted {
            $0.createdAt < $1.createdAt
        }
    }
    
    func save() async throws {
        try await coreDataService.perform {
            try $0.persistChanges()
        }
    }
}
