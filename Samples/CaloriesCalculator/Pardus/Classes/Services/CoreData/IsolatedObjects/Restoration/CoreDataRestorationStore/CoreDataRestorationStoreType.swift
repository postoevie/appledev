//
//  CoreDataRestorationStoreType.swift
//  Pardus
//
//  Created by Igor Postoev on 31.5.24.
//	
//

import Foundation

/// Contains Restoration items
protocol CoreDataRestorationStoreType {
    
    /// Its supposed that view has only one restoratioin item.
    /// - Returns: Restoration itam containing current in-memory data for view.
    func restore(key: Views) -> CoreDataRestorationItem?
    
    /// Stores current view data
    func store(key: Views, item: CoreDataRestorationItem)
    
    /// Clears stored data for view
    func clear(key: Views)
}
