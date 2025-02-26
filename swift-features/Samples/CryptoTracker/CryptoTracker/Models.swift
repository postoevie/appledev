//
//  Models.swift
//  CryptoTracker
//
//  Created by Igor Postoev on 21.2.25..
//

import SwiftData

@Model
class Coin {
    
    var name: String
    var price: Double
    
    init(name: String, price: Double) {
        self.name = name
        self.price = price
    }
}
