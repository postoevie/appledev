//
//  CoreDataStackService.swift
//  Pardus
//
//  Created by Igor Postoev on 19.5.24.
//	
//

import Foundation
import CoreData

class CoreDataStackService: CoreDataStackServiceType {
    
    let dataStack: CoreDataStack
    
    init(inMemory: Bool) {
        let stack = CoreDataStack()
        stack.setup(inMemory: inMemory)
        dataStack = stack
        do {
            try makeFirstLaunchData(in: stack.mainQueueContext)
        } catch {
            print(error) // TODO: P-58
        }
    }
    
    func getMainQueueContext() -> NSManagedObjectContext {
        dataStack.mainQueueContext
    }
    
    func makeChildMainQueueContext() -> NSManagedObjectContext {
        dataStack.makeStubMainQueueContext()
    }
    
    private func makeFirstLaunchData(in context: NSManagedObjectContext) throws {
        guard UserDefaults.standard.string(forKey: "com.pardus.firstStartupData") == nil else {
            return
        }
        let coreDataService = CoreDataService(context: context)
        try coreDataService.syncPerform { executor in
            
            // Create dish categories
            let saladsCategory = try executor.create(type: DishCategory.self, id: UUID())
            saladsCategory.name = "Salads"
            saladsCategory.colorHex = "#02A50C"
            
            let soupsCategory = try executor.create(type: DishCategory.self, id: UUID())
            soupsCategory.name = "Soups"
            soupsCategory.colorHex = "#C9A203"
            
            // Create dishes
            let chickenSalad = try executor.create(type: Dish.self, id: UUID())
            chickenSalad.name = "Chicken salad"
            chickenSalad.category = saladsCategory
            
            let tomatoSoup = try executor.create(type: Dish.self, id: UUID())
            tomatoSoup.id = UUID()
            tomatoSoup.name = "Tomato soup"
            tomatoSoup.category = soupsCategory
            
            // Create first meal
            let meal1 = try executor.create(type: Meal.self, id: UUID())
            meal1.date = Date()
            meal1.dishes = Set()
            
            // Add dishes to meal
            let saladMealDish = try executor.create(type: MealDish.self, id: UUID())
            saladMealDish.meal = meal1
            saladMealDish.dish = chickenSalad
            saladMealDish.name = chickenSalad.name
            
            let soupMealDish = try executor.create(type: MealDish.self, id: UUID())
            soupMealDish.meal = meal1
            soupMealDish.dish = tomatoSoup
            soupMealDish.name = tomatoSoup.name
            
            let meal2 = try executor.create(type: Meal.self, id: UUID())
            meal2.id = UUID()
            meal2.date = Calendar.current.date(byAdding: .day,
                                               value: 1,
                                               to: Date()) ?? Date()
            meal2.dishes = Set()
            
            let meal3 = try executor.create(type: Meal.self, id: UUID())
            meal3.id = UUID()
            meal3.date = Date()
            meal3.dishes = Set()
            
            try? context.save()
        }
        
        UserDefaults.standard.setValue(Date().formatted(), forKey: "com.pardus.firstStartupData")
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
