//
//  MealDish.swift
//  Pardus
//
//  Created by Igor Postoev on 13.8.24..
//

import CoreData

@objc(MealDish)
class MealDish: IdentifiedManagedObject {
    
    @NSManaged var name: String
    @NSManaged var meal: Meal
    @NSManaged var dish: Dish?
    @NSManaged var ingridients: Set<MealIngridient>
    
    var weight: Double {
        ingridients.reduce(0) { acc, ingridient in
            acc + ingridient.weight
        }
    }
    
    var calories: Double {
        ingridients.reduce(0) { acc, ingridient in
            acc + ingridient.calories
        }
    }
    
    var proteins: Double {
        ingridients.reduce(0) { acc, ingridient in
            acc + ingridient.proteins
        }
    }
    
    var fats: Double {
        ingridients.reduce(0) { acc, ingridient in
            acc + ingridient.fats
        }
    }
    
    var carbs: Double {
        ingridients.reduce(0) { acc, ingridient in
            acc + ingridient.carbs
        }
    }
}
