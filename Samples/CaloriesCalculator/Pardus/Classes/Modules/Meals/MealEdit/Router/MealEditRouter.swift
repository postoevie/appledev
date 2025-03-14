//
//  MealEditRouter.swift
//  Pardus
//
//  Created by Igor Postoev on 18.5.24.
//
//

import Foundation

final class MealEditRouter: MealEditRouterProtocol {
    
    private var navigation: any NavigationServiceType
    
    init(navigation: any NavigationServiceType) {
        self.navigation = navigation
    }
    
    func returnBack() {
        _ = navigation.mealsItems.popLast()
    }
    
    func showEditDish(dishId: UUID) {
        navigation.mealsItems.append(.mealDishEdit(mealDishId: dishId))
    }
    
    func hidePicklist() {
        navigation.modalView = nil
    }
}
