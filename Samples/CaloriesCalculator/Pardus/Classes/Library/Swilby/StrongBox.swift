//
//  StrongBox.swift
//  Pardus
//
//  Created by Igor Postoev on 11.5.24.
//  
//

import Foundation

protocol StrongBox: AnyObject {
    var strongBoxHolder: [String: AnyObject] { get set }
}

extension StrongBox {
    
    func strongBox<T>(_ configure: () -> T) -> T {
        let key = ObjectKey(T.self).key
        if let object = self.strongBoxHolder[key] as? T {
            return object
        }
        let object = configure()
        strongBoxHolder[key] = object as AnyObject
        return object
    }
}
