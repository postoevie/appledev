//
//  MealEditViewState.swift
//  Pardus
//
//  Created by Igor Postoev on 18.5.24.
//  
//

import SwiftUI

final class MealEditViewState: MealEditViewStateProtocol {
    
    @Published var date: Date = Date()
    @Published var error: String?
    @Published var dishItems: [MealDishesListItem] = []
    @Published var weight: String = ""
    @Published var sumKcals: String = ""
    @Published var sumProteins: String = ""
    @Published var sumFats: String = ""
    @Published var sumCarbs: String = ""

    func set(items: [MealDishesListItem]) {
        self.dishItems = items
    }
}
