//
//  Formatter+DishFormat.swift
//  Pardus
//
//  Created by Igor Postoev on 13.8.24..
//

import Foundation

extension Formatter {
    
    // Opt for singleton instead of DI and service because here will be no business logic.
    static let nutrients: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        return formatter
    }()
    
    static func nutrientsDefaultString(calories: Double,
                                       proteins: Double,
                                       fats: Double,
                                       carbs: Double) -> String {
        let formatter = Formatter.nutrients
        let calString = formatter.string(for: calories) ?? "0"
        let proteinsString = formatter.string(for: proteins) ?? "0"
        let fatsString = formatter.string(for: fats) ?? "0"
        let carbsString = formatter.string(for: carbs) ?? "0"
        return "\(calString) kcal \(proteinsString)/\(fatsString)/\(carbsString)"
    }
}
