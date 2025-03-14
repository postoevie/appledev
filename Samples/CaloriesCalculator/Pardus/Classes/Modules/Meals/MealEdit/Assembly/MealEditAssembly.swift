//
//  MealEditAssembly.swift
//  Pardus
//
//  Created by Igor Postoev on 18.5.24.
//
//

import SwiftUI

final class MealEditAssembly: Assembly {
    
    func build(mealId: UUID?) -> some View {
        
        let navigation = container.resolve(NavigationAssembly.self).build()
        
        // Router
        let router = MealEditRouter(navigation: navigation)
        
        // Interactor
        let coreDataStackService = container.resolve(CoreDataStackServiceAssembly.self).build()
        let coreDataService = CoreDataService(context: coreDataStackService.getMainQueueContext())
        let interactor = MealEditInteractor(coreDataService: coreDataService, mealId: mealId)
        
        // ViewState
        let viewState = MealEditViewState()
        
        // Presenter
        let presenter = MealEditPresenter(router: router, interactor: interactor, viewState: viewState)
        
        // View
        let view = MealEditView(viewState: viewState, presenter: presenter)
        return view
    }
}
