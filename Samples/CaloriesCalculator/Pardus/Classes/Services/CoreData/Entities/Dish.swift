//
//  Dish.swift
//  Pardus
//
//  Created by Igor Postoev on 1.6.24..
//

import CoreData

@objc(Dish)
class Dish: IdentifiedManagedObject {
    
    @NSManaged var name: String
    @NSManaged var category: DishCategory?
    @NSManaged var ingridients: Set<Ingridient>
}
