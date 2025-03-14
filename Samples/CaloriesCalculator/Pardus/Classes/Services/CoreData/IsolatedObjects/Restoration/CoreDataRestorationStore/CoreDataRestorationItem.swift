//
//  CoreDataRestorationItem.swift
//  Pardus
//
//  Created by Igor Postoev on 28.7.24..
//

import CoreData

struct CoreDataRestorationItem {
    
    let entityCaches: [String: any EntityCacheType]
    let context: NSManagedObjectContext
}
