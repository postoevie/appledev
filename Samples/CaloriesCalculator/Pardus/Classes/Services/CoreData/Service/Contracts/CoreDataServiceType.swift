//
//  CoreDataServiceType.swift
//  Pardus
//
//  Created by Igor Postoev on 12.8.24..
//

import CoreData

protocol CoreDataServiceType: AnyObject {
    
    /// Safely performs given action in syncronous manner
    ///
    /// - Parameter action: Completion which retreives database actions executor. 
    /// Violating completion scope with managed objects/contexts can lead to unpredictable subsequences.
    ///
    /// Code example
    /// ```
    ///  try interaction.syncPerform { executor in
    ///    let accounts = executor.fetchMany(Account.self, predicate: accountPredicate)
    ///    accounts.forEach { $0.setValueSafely(nil, forKey: "name") }
    ///    executor.persistChanges()
    ///  }
    ///  ```
    func syncPerform(action: (CoreDataExecutorType) throws -> Void) rethrows
    
    func perform(action: @escaping (CoreDataExecutorType) throws -> Void) async rethrows
}
