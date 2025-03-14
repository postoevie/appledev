//
//  RootPresenter.swift
//  Pardus
//
//  Created by Igor Postoev on 2.12.24.
//  
//

import SwiftUI

final class RootPresenter: RootPresenterProtocol, ObservableObject {
    
    private let router: RootRouterProtocol
    private let interactor: RootInteractorProtocol
    
    init(router: RootRouterProtocol,
         interactor: RootInteractorProtocol) {
        self.router = router
        self.interactor = interactor
    }
    
    func onAppear() {
        interactor.startMemoryPressureObservation()
        interactor.restoreRecords()
        router.showStartScreen()
    }
}
