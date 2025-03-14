//
//  MealsListAssembly.swift
//  Pardus
//
//  Created by Igor Postoev on 18.5.24.
//
//

import SwiftUI

final class MealsListAssembly: Assembly {
    
    func build() -> some View {
        
        let navigation = container.resolve(NavigationAssembly.self).build()
        
        // Router
        let router = MealsListRouter(navigation: navigation)
        
        // Interactor
        let coreDataStackService = container.resolve(CoreDataStackServiceAssembly.self).build()
        let dataService = CoreDataService(context: coreDataStackService.getMainQueueContext())
        let interactor = MealsListInteractor(dataService: dataService)
        
        // ViewState
        let viewState = MealsListViewState()
        
        // Presenter
        let presenter = MealsListPresenter(router: router,
                                           interactor: interactor,
                                           viewState: viewState)
        
        viewState.set(presenter: presenter)
        
        // View
        let view = MealsListView(viewState: viewState, presenter: presenter)
        return view
    }
}
