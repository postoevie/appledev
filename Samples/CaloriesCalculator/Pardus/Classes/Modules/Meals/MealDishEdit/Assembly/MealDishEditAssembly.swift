//
//  MealEditAssembly.swift
//  Pardus
//
//  Created by Igor Postoev on 18.5.24.
//
//

import SwiftUI

final class MealDishEditAssembly: Assembly {
    
    func build(mealDishId: UUID?) -> some View {
        
        let navigation = container.resolve(NavigationAssembly.self).build()
        
        // Router
        let router = MealDishEditRouter(navigation: navigation)
        
        // Interactor
        let coreDataStackService = container.resolve(CoreDataStackServiceAssembly.self).build()
        let coreDataService = CoreDataService(context: coreDataStackService.getMainQueueContext())
        let interactor = MealDishEditInteractor(coreDataService: coreDataService, mealDishId: mealDishId)
        
        // ViewState
        let viewState = MealDishEditViewState()
        
        // Presenter
        let presenter = MealDishEditPresenter(router: router, interactor: interactor, viewState: viewState)
        
        // View
        let view = MealDishEditView(viewState: viewState, presenter: presenter)
        return view
    }
}
