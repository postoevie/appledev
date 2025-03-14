//
//  DishEditRouter.swift
//  Pardus
//
//  Created by Igor Postoev on 2.6.24.
//  
//

import Foundation

final class MealIngridientEditRouter: MealIngridientEditRouterProtocol {
    
    private var navigation: any NavigationServiceType
    
    init(navigation: any NavigationServiceType) {
        self.navigation = navigation
    }
    
    func returnBack() {
        _ = navigation.mealsItems.popLast()
    }
}
