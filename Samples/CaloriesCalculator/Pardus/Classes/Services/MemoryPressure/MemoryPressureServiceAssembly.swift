//
//  MemoryPressureServiceAssembly.swift
//  Pardus
//
//  Created by Igor Postoev on 6.1.25..
//

final class MemoryPressureServiceAssembly: Assembly {
    
    func build() -> MemoryPressureService {
        strongBox {
            let coreDataService = container.resolve(CoreDataStackServiceAssembly.self).build()
            return MemoryPressureService(coreDataStackService: coreDataService)
        }
    }
}
