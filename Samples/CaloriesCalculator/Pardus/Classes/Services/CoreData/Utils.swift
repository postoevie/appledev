//
//  Utils.swift
//  Pardus
//
//  Created by Igor Postoev on 31.5.24..
//

import CoreData

extension NSManagedObjectContext {
    
    func fetchAndPrint<T: EntityModelType>(_ type: T.Type, predicate: NSPredicate = NSPredicate(value: true)) {
        Task {
            let result = try await getResult(type, predicate: predicate)
            print(result)
        }
    }
    
    func getResult<T: EntityModelType>(_ type: T.Type, predicate: NSPredicate) async throws -> [T] {
        try await CoreDataEntityService(context: self,
                                        caches: [:],
                                        restoration: MockRestorationStore()).fetch(predicate: predicate)
    }
}

private class MockRestorationStore: CoreDataRestorationStoreType {
    func clear(key: Views) {
        
    }
    
    func restore(key: Views) -> CoreDataRestorationItem? {
        nil
    }
    
    func store(key: Views, item: CoreDataRestorationItem) {

    }
}
