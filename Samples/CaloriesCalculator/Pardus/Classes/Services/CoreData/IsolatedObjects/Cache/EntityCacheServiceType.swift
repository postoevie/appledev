//
//  EntityCacheServiceType.swift
//  Pardus
//
//  Created by Igor Postoev on 27.5.24..
//

import Foundation

protocol EntityCacheServiceType {
    
    func cache<EntityModel>(predicate: NSPredicate, modelType: EntityModel.Type) async throws
    func cache<EntityModel: EntityModelType>(models: [EntityModel]) async throws
    func fetchCached<EntityModel>(predicate: NSPredicate?) throws -> [EntityModel] where EntityModel: EntityModelType
    func uncache<EntityModel>(models: [EntityModel]) throws where EntityModel: EntityModelType
    func updateCached<EntityModel>(models: [EntityModel]) async throws where EntityModel: EntityModelType
}
