//
//  RootContracts.swift
//  Pardus
//
//  Created by Igor Postoev on 2.12.24.
//  
//

import SwiftUI

// Router
protocol RootRouterProtocol: RouterProtocol {

    func showStartScreen()
}

// Presenter
protocol RootPresenterProtocol: PresenterProtocol {

}

// Interactor
protocol RootInteractorProtocol: InteractorProtocol {

    func startMemoryPressureObservation()
    func restoreRecords()
}
