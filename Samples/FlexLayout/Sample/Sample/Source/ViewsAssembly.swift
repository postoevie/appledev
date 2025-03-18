//
//  Coordinator.swift
//  Sample
//
//  Created by Igor Postoev on 20.3.24..
//

import FlexLayout

struct ViewsAssembly {
    
    static func createFlexItemsModule() -> UIViewController {
        let controller = FlexItemsController()
        let dataInteraction = FlexItemsDataInteraction()
        let presenter = FlexItemsPresenter(settingsProvider: dataInteraction,
                                           dataService: dataInteraction)
        controller.presenter = presenter
        
        let sections = presenter.createSections()
        let assembly = FLAssembly(sections: sections)
        let result = assembly.build().first!
        
        presenter.interaction = result.interaction
        controller.addChildAndSetView(controller: result.controller)
        return controller
    }
}
