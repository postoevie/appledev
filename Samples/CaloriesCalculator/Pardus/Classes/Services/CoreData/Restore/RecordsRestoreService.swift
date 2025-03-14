//
//  CoreDataRecordsRestoreService.swift
//  Pardus
//
//  Created by Igor Postoev on 2.12.24..
//

final class RecordsRestoreService: RecordsRestoreServiceType {
    
    let coreDataService: CoreDataServiceType
    
    init(coreDataService: CoreDataServiceType) {
        self.coreDataService = coreDataService
    }
    
    func restoreRecords(snapshot: RecordsStateSnapshot) {
        do {
            try coreDataService.syncPerform { executor in
                
                // Restore records attributes
                let dishCategories = try snapshot.dishCategories.map { uid, data in
                    let category = try executor.create(type: DishCategory.self, id: uid)
                    category.name = data.name
                    return category
                }
                
                let dishes = try snapshot.dishes.map { uid, data in
                    let dish = try executor.create(type: Dish.self, id: uid)
                    dish.name = data.name
                    return dish
                }
                
                let ingridientCategories = try snapshot.ingridientCategories.map { uid, data in
                    let category = try executor.create(type: IngridientCategory.self, id: uid)
                    category.name = data.name
                    return category
                }
                
                let ingridients = try snapshot.ingridients.map { uid, data in
                    let ingridient = try executor.create(type: Ingridient.self, id: uid)
                    ingridient.name = data.name
                    ingridient.calories = data.calories
                    ingridient.proteins = data.proteins
                    ingridient.fats = data.fats
                    ingridient.carbs = data.carbs
                    return ingridient
                }
                
                // Restore records relations
                for dish in dishes {
                    if let categoryId = snapshot.dishes[dish.id]?.categoryId,
                       let category = dishCategories.first(where: { $0.id == categoryId }) {
                        dish.category = category
                    }
                    if let ingridientIds = snapshot.dishes[dish.id]?.ingridientIds {
                        let ingridients = ingridients.filter { ingridientIds.contains($0.id) }
                        dish.ingridients = Set(ingridients)
                    }
                }
                
                for ingridient in ingridients {
                    guard let categoryId = snapshot.ingridients[ingridient.id]?.categoryId,
                          let category = ingridientCategories.first(where: { $0.id == categoryId }) else {
                        continue
                    }
                    ingridient.category = category
                }
                
                try executor.persistChanges()
            }
        } catch {
            print("Error while restore records data: \(error)")
        }
    }
}
