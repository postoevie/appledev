//
//  MealEditInteractor.swift
//  Pardus
//
//  Created by Igor Postoev on 18.5.24.
//
//

import Foundation

class MealEditInteractor: MealEditInteractorProtocol {
    
    var mealId: UUID?
    
    private var meal: Meal?
    
    private let coreDataService: CoreDataServiceType
    
    var dishesFilter: Predicate? {
        var dishesIds = [UUID]()
        coreDataService.syncPerform { _ in
            guard let dishes = meal?.dishes else {
                return
            }
            dishesIds = dishes.compactMap { $0.dish?.id }
        }
        
        return .idNotIn(uids: dishesIds)
    }
    
    init(coreDataService: CoreDataServiceType, mealId: UUID?) {
        self.coreDataService = coreDataService
        self.mealId = mealId
    }
    
    func loadInitialMeal() async throws {
        guard meal == nil else {
            return
        }
        try await coreDataService.perform {
            if let mealId = self.mealId {
                self.meal = try $0.fetchOne(type: Meal.self, predicate: .idIn(uids: [mealId]))
                return
            }
            let newMeal = try $0.create(type: Meal.self, id: UUID())
            newMeal.date = Date()
            self.mealId = newMeal.id
            self.meal = newMeal
        }
    }
    
    func createMealDish() async throws -> UUID {
        guard let meal else {
            assertionFailure()
            throw MealDishError.noEntity
        }
        let mealDishId = UUID()
        try await coreDataService.perform {
            let mealDish = try $0.create(type: MealDish.self, id: mealDishId)
            mealDish.meal = meal
        }
        return mealDishId
    }
    
    func remove(dishId: UUID) async throws {
        guard let meal else {
            assertionFailure()
            return
        }
        try await coreDataService.perform {
            if let mealDish = meal.dishes[dishId] {
                try $0.delete(objectId: mealDish.objectID)
            }
        }
    }
    
    func performWithMeal(action: @escaping (Meal?) -> Void) async throws {
        await coreDataService.perform { _ in
            action(self.meal)
        }
    }
    
    func performWithMealDishes(action: @escaping ([MealDish]) -> Void) async throws {
        await coreDataService.perform { _ in
            guard let meal = self.meal else {
                action([])
                return
            }
            let mealDishes = Array(meal.dishes)
            action(self.sorted(mealDishes))
        }
    }
    
    private func sorted(_ mealDishes: [MealDish]) -> [MealDish] {
        mealDishes.sorted {
            $0.createdAt < $1.createdAt
        }
    }
    
    func save() async throws {
        try await coreDataService.perform {
            try $0.persistChanges()
        }
    }
    
    func setSelectedDishes(_ dishesIds: Set<UUID>) async throws {
        guard let meal else {
            return
        }
        try await coreDataService.perform {
            let dishesToAdd = try $0.fetchMany(type: Dish.self,
                                               predicate: NSPredicate.idIn(uids: Array(dishesIds)),
                                               sortBy: SortParams(fieldName: (\Dish.name).fieldName, ascending: true))
            for dish in dishesToAdd {
                let mealDish = try $0.create(type: MealDish.self, id: UUID())
                mealDish.dish = dish
                mealDish.meal = meal
                mealDish.name = dish.name
                for ingridient in dish.ingridients {
                    try self.makeMealIngridient($0, mealDish: mealDish, ingridient: ingridient)
                }
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
}

// MARK: Private
extension MealEditInteractor {
    
}

extension Set where Element: Identifiable<UUID> {
    
    subscript(id: UUID) -> Element? {
        self.first { $0.id == id }
    }
}
