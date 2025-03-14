//
//  Ingridient.swift
//  Pardus
//
//  Created by Igor Postoev on 29.10.24..
//

import CoreData

@objc(Ingridient)
class Ingridient: IdentifiedManagedObject {
    
    @NSManaged var name: String
    @NSManaged var category: IngridientCategory?
    @NSManaged var calories: Double
    @NSManaged var proteins: Double
    @NSManaged var fats: Double
    @NSManaged var carbs: Double
}
