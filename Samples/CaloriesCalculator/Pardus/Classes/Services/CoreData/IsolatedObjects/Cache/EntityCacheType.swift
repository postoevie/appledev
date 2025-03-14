//
//  EntityCacheType.swift
//  Pardus
//
//  Created by Igor Postoev on 27.5.24..
//

import Foundation

protocol EntityCacheType {
    
    func pull(predicate: NSPredicate?) throws -> [EntityModelType]
    func cache(predicate: NSPredicate?) async throws
    func cache(models: [EntityModelType]) async throws
    func uncache(predicate: NSPredicate)
    func uncache(models: [EntityModelType])
    func update(models: [EntityModelType]) throws
}
