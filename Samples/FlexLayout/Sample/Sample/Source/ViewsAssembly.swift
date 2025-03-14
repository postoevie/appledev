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
        let presenter = FieldsPresenter(settingsProvider: dataInteraction,
                                                   dataService: dataInteraction)
        controller.presenter = presenter
        
        let sections = presenter.createSections()
        let coordinator = FLCoordinator(sections: sections, actionsDelegate: presenter)
        let result = coordinator.buildSectionViews().first!
        
        presenter.interaction = result.interaction
        controller.addChildAndSetView(controller: result.controller)
        return controller
    }
}
