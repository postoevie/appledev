//
//  NSManagedObjectContext.swift
//  Pardus
//
//  Created by Igor Postoev on 19.5.24..
//

import CoreData

extension NSManagedObjectContext {
    
    func persist() throws {
        do {
            try performAndWait {
                guard hasChanges else {
                    return
                }
                try self.save()
                if let parent {
                    try parent.persist()
                }
            }
        } catch let error as NSError where error.userInfo["NSValidationErrorObject"] != nil {
            rollback()
            throw CoreDataError.databaseError(error.localizedDescription)
        } catch {
            throw CoreDataError.databaseError(error.localizedDescription)
        }
    }
}
