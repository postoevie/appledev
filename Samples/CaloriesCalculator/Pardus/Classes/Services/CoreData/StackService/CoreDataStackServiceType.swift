//
//  CoreDataStackServiceType.swift
//  Pardus
//
//  Created by Igor Postoev on 19.5.24.
//	
//

import Foundation
import CoreData

protocol CoreDataStackServiceType {
    
    /// Fetches app's main context on main thread
    func getMainQueueContext() -> NSManagedObjectContext
    
    /// Creates child context working with main queue
    func makeChildMainQueueContext() -> NSManagedObjectContext
}
