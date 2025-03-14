//
//  CoreDataRecordsRestoreServiceAssembly.swift
//  Pardus
//
//  Created by Igor Postoev on 2.12.24..
//

final class RecordsRestoreServiceAssembly: Assembly {
    
    func build() -> RecordsRestoreServiceType {
        let coreDataStackService = container.resolve(CoreDataStackServiceAssembly.self).build()
        let coreDataService = CoreDataService(context: coreDataStackService.getMainQueueContext())
        return RecordsRestoreService(coreDataService: coreDataService)
    }
}
