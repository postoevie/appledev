//
//  CoreDataRestorationStore.swift
//  Pardus
//
//  Created by Igor Postoev on 31.5.24.
//	
//

import Foundation

import CoreData
import Combine

class CoreDataRestorationStore: CoreDataRestorationStoreType {
    
    var restorationItems: [Views: CoreDataRestorationItem] = [:]
    
    func restore(key: Views) -> CoreDataRestorationItem? {
        restorationItems[key]
    }
    
    func store(key: Views, item: CoreDataRestorationItem) {
        restorationItems[key] = item
    }
    
    func clear(key: Views) {
        restorationItems[key] = nil
    }
}
