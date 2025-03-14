//
//  CoreDataRestorationStoreAssembly.swift
//  Pardus
//
//  Created by Igor Postoev on 31.5.24.
//	
//

import Foundation

class CoreDataRestorationStoreAssembly: Assembly {
    
    func build() -> CoreDataRestorationStoreType {
        strongBox {
            CoreDataRestorationStore()
        }
    }
}
