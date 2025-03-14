//
//  MealEditViewState.swift
//  Pardus
//
//  Created by Igor Postoev on 18.5.24.
//  
//

import SwiftUI

final class MealDishEditViewState: ObservableObject, MealDishEditViewStateProtocol {
    
    @Published var error: String?
    @Published var name: String = ""
    @Published var ingridients: [MealDishesIngridientsListItem] = []
    @Published var sumKcals: String = ""
    @Published var weight: String = ""
    @Published var sumProteins: String = ""
    @Published var sumFats: String = ""
    @Published var sumCarbs: String = ""

    func set(ingridients: [MealDishesIngridientsListItem]) {
        self.ingridients = ingridients
    }
}
