//
//  MealIngridient.swift
//  Pardus
//
//  Created by Igor Postoev on 29.10.24..
//

import CoreData

@objc(MealIngridient)
class MealIngridient: IdentifiedManagedObject {
    
    @NSManaged var dish: MealDish
    @NSManaged var name: String
    @NSManaged var weight: Double
    @NSManaged var caloriesPer100: Double
    @NSManaged var proteinsPer100: Double
    @NSManaged var fatsPer100: Double
    @NSManaged var carbsPer100: Double
    @NSManaged var ingridient: Ingridient?
    
    var calories: Double {
        caloriesPer100 * weight / 100
    }
    
    var proteins: Double {
        proteinsPer100 * weight / 100
    }
    
    var fats: Double {
        fatsPer100 * weight / 100
    }
    
    var carbs: Double {
        carbsPer100 * weight / 100
    }
}
