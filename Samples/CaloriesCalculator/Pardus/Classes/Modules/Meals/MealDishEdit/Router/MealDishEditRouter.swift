//
//  MealEditRouter.swift
//  Pardus
//
//  Created by Igor Postoev on 18.5.24.
//
//

import Foundation

final class MealDishEditRouter: MealDishEditRouterProtocol {
    
    private var navigation: any NavigationServiceType
    
    init(navigation: any NavigationServiceType) {
        self.navigation = navigation
    }
    
    func returnBack() {
        _ = navigation.mealsItems.popLast()
    }
    
    func hidePicklist() {
        navigation.modalView = nil
    }
    
    func showMealIngridient(ingridientId: UUID) {
        navigation.mealsItems.append(.mealIngridientEdit(ingridientId: ingridientId))
    }
}
