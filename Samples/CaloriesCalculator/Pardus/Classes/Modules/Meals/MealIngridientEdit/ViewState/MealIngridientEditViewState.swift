//
//  DishEditViewState.swift
//  Pardus
//
//  Created by Igor Postoev on 2.6.24.
//  
//

import SwiftUI

final class MealIngridientEditViewState: ObservableObject, MealIngridientEditViewStateProtocol {
    
    @Published var name: String = ""
    @Published var weight: String = ""
    @Published var caloriesPer100: String = ""
    @Published var proteinsPer100: String = ""
    @Published var fatsPer100: String = ""
    @Published var carbsPer100: String = ""
    @Published var calories: String = ""
    @Published var proteins: String = ""
    @Published var fats: String = ""
    @Published var carbohydrates: String = ""
    @Published var error: String?
}
