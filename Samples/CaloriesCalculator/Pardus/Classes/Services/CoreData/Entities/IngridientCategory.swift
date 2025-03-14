//
//  IngridientCategory.swift
//  Pardus
//
//  Created by Igor Postoev on 31.10.24..
//

import Foundation

@objc(IngridientCategory)
class IngridientCategory: IdentifiedManagedObject {
    
    @NSManaged var name: String
    @NSManaged var colorHex: String?
    @NSManaged var ingridients: Set<Ingridient>
}
