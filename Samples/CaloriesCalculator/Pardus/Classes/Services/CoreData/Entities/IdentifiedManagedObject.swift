//
//  IdentifiedManagedObject.swift
//  Pardus
//
//  Created by Igor Postoev on 23.5.24..
//

import CoreData

@objc
class IdentifiedManagedObject: NSManagedObject, Identifiable {
    
    @NSManaged var id: UUID
    @NSManaged var createdAt: Date
}
