//
//  KeyPath+Extension.swift
//  Pardus
//
//  Created by Igor Postoev on 23.5.24..
//

import CoreData

extension KeyPath where Root: NSManagedObject {
    
    var fieldName: String {
        let propName = NSExpression(forKeyPath: self).keyPath
        guard let prop = Root.entity().propertiesByName[propName] else {
            return propName
        }
        return prop.name
    }
}
