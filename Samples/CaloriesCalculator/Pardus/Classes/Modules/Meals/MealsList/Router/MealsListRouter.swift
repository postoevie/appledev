//
//  MealsListRouter.swift
//  Pardus
//
//  Created by Igor Postoev on 18.5.24.
//  
//

import Foundation

final class MealsListRouter: MealsListRouterProtocol {

    private var navigation: any NavigationServiceType
    
    init(navigation: any NavigationServiceType) {
        self.navigation = navigation
    }
    
    func showAdd() {
        navigation.mealsItems.append(.mealEdit(mealId: nil))
    }
    
    func showEdit(mealId: UUID) {
        navigation.mealsItems.append(.mealEdit(mealId: mealId))
    }
}
