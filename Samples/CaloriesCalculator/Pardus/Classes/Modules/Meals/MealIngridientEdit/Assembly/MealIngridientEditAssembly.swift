//
//  MealIngridientEditAssembly.swift
//  Pardus
//
//  Created by Igor Postoev on 2.6.24.
//  
//

import SwiftUI

final class MealIngridientEditAssembly: Assembly {
    
    func build(ingridientId: UUID?) -> some View {
        
        let navigation = container.resolve(NavigationAssembly.self).build()

        // Router
        let router = MealIngridientEditRouter(navigation: navigation)

        // Interactor
        let coreDataStackService = container.resolve(CoreDataStackServiceAssembly.self).build()
        let coreDataService = CoreDataService(context: coreDataStackService.getMainQueueContext())
        let interactor = MealIngridientEditInteractor(coreDataService: coreDataService, ingridientId: ingridientId)

        // ViewState
        let viewState = MealIngridientEditViewState()

        // Presenter
        let presenter = MealIngridientEditPresenter(router: router, interactor: interactor, viewState: viewState)
        
        // View
        let view = MealIngridientEditView(viewState: viewState, presenter: presenter)
        return view
    }
}
