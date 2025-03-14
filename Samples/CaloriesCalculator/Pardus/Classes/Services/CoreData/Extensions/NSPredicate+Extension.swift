//
//  NSPredicate+Extension.swift
//  Pardus
//
//  Created by Igor Postoev on 23.5.24..
//

import Foundation

extension NSPredicate {
    
    static func idIn(uids: [UUID]) -> NSPredicate {
        NSPredicate(format: "id in %@", uids)
    }
    
    static func `in`(fieldName: String, argument: CVarArg) -> NSPredicate {
        NSPredicate(format: "\(fieldName) in %@", argument)
    }
    
    static func contains(fieldName: String, argument: CVarArg) -> NSPredicate {
        NSPredicate(format: "\(fieldName) contains %@", argument)
    }
    
    static func equal(fieldName: String, argument: CVarArg) -> NSPredicate {
        NSPredicate(format: "\(fieldName) = %@", argument)
    }
}

enum PredicateError: Error {
    
    case incompatibleArgument
}

enum Predicate {
    
    case idIn(uids: [UUID])
    case idNotIn(uids: [UUID])
    case `in`(fieldName: String, argument: Any?) // swiftlint:disable:this identifier_name
    case notIn(fieldName: String, argument: Any?)
    case equal(fieldName: String, argument: Any?)
}

extension NSPredicate {
    
    static func map(predicate: Predicate?) throws -> NSPredicate? {
        guard let predicate else {
            return nil
        }
        switch predicate {
        case .idIn(uids: let uids):
            return NSPredicate(format: "id in %@", uids)
        case .idNotIn(uids: let uids):
            return NSPredicate(format: "not (id in %@)", uids)
        case .in(let fieldName, let argument):
            return NSPredicate(format: "\(fieldName) in %@", try mapToVarArg(argument))
        case .notIn(let fieldName, let argument):
            return NSPredicate(format: "not (\(fieldName) in %@)", try mapToVarArg(argument))
        case .equal(let fieldName, let argument):
            return NSPredicate(format: "\(fieldName) == %@", try mapToVarArg(argument))
        }
    }
    
    static private func mapToVarArg(_ value: Any?) throws -> CVarArg {
        if value == nil {
            return "nil"
        }
        if let argument = value as? CVarArg {
            return argument
        }
        throw PredicateError.incompatibleArgument
    }
}
