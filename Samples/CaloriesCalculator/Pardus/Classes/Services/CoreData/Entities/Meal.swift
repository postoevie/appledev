//
//  Meal.swift
//  Pardus
//
//  Created by Igor Postoev on 19.5.24..
//

import CoreData

@objc(Meal)
class Meal: IdentifiedManagedObject {
    
    @NSManaged var date: Date
    @NSManaged var dishes: Set<MealDish>
    
    var weight: Double {
        return dishes.reduce(0) { acc, dish in
            acc + dish.weight
        }
    }
    
    var calories: Double {
        return dishes.reduce(0) { acc, dish in
            acc + dish.calories
        }
    }
    
    var proteins: Double {
        return dishes.reduce(0) { acc, dish in
            acc + dish.proteins
        }
    }
    
    var fats: Double {
        return dishes.reduce(0) { acc, dish in
            acc + dish.fats
        }
    }
    
    var carbs: Double {
        return dishes.reduce(0) { acc, dish in
            acc + dish.carbs
        }
    }
}
