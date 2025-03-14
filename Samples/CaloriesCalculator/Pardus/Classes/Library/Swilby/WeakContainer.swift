//
//  WeakContainer.swift
//  Pardus
//
//  Created by Igor Postoev on 11.5.24.
//  
//

import Foundation

class WeakContainer<T> {
    fileprivate weak var _value: AnyObject?
    var value: T? {
        get { return _value as? T }
        set { self._value = newValue as AnyObject }
    }
    
    init(value: T) {
        self._value = value as AnyObject
    }
}
