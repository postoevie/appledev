//
//  EntityServiceAssembly.swift
//  Pardus
//
//  Created by Igor Postoev on 23.5.24.
//	
//

import CoreData

class EntityServiceAssembly: Assembly {
    
    func build(context: NSManagedObjectContext,
               caches: [String: any EntityCacheType],
               restoration: CoreDataRestorationStoreType) -> EntityModelServiceType {
        CoreDataEntityService(context: context,
                              caches: caches,
                              restoration: restoration)
    }
}
