//
//  RootRouter.swift
//  Pardus
//
//  Created by Igor Postoev on 2.12.24.
//  
//

import Foundation

final class RootRouter: RootRouterProtocol {
    
    private let navigationService: any NavigationServiceType
    
    init(navigationService: any NavigationServiceType) {
        self.navigationService = navigationService
    }
    
    func showStartScreen() {
        if let snapshot = getViewSnapshot() {
            apply(snapshot: snapshot)
        }
    }
    
    private func getViewSnapshot() -> ViewsStateSnapshot? {
        do {
            return try getUITestSnapshot()
        } catch {
            print() // TODO: P-58 Analytics
        }
        return nil
    }
    
    private func apply(snapshot: ViewsStateSnapshot) {
        navigationService.tab = snapshot.tab
        navigationService.mealsItems = snapshot.mealsItems
    }
    
    private func getUITestSnapshot() throws -> ViewsStateSnapshot? {
        guard let uiTestViewPath = EnvironmentUtils.uiTestsViewSnapshotPath,
              let uiTestData = FileManager.default.contents(atPath: uiTestViewPath) else {
            return nil
        }
        return try JSONDecoder().decode(ViewsStateSnapshot.self, from: uiTestData)
    }
}
