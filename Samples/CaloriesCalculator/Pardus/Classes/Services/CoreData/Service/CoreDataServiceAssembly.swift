//
//  CoreDataServiceAssembly.swift
//  Pardus
//
//  Created by Igor Postoev on 12.8.24..
//

import CoreData

class CoreDataServiceAssembly: Assembly {
    
    func build(context: NSManagedObjectContext) -> CoreDataServiceType {
        CoreDataService(context: context)
    }
}
