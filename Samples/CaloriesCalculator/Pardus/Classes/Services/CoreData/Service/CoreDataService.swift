//
//  CoreDataService.swift
//  Pardus
//
//  Created by Igor Postoev on 12.8.24..
//

import CoreData

class CoreDataService: CoreDataServiceType {
    
    let context: NSManagedObjectContext
    let executor: CoreDataExecutorType
    
    init(context: NSManagedObjectContext) {
        self.context = context
        self.executor = CoreDataExecutor(context: context)
    }
    
    func syncPerform(action: (CoreDataExecutorType) throws -> Void) rethrows {
        // Assures block of ops will be implemented in a single context
        try context.performAndWait {
            try action(executor)
        }
    }
    
    func perform(action: @escaping (CoreDataExecutorType) throws -> Void) async rethrows {
        // Assures block of ops will be implemented in a single context
        try await context.perform {
            try action(self.executor)
        }
    }
}
