//
//  CoreDataStackServiceAssembly.swift
//  Pardus
//
//  Created by Igor Postoev on 19.5.24.
//	
//

import Foundation

class CoreDataStackServiceAssembly: Assembly {
    
    func build() -> CoreDataStackServiceType {
        strongBox {
            CoreDataStackService(inMemory: EnvironmentUtils.isInPreview || EnvironmentUtils.isInUITests)
        }
    }
}
