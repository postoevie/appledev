//
//  NavigationAssembly.swift
//  Pardus
//
//  Created by Igor Postoev on 11.5.24.
//  
//

import Foundation

final class NavigationAssembly: Assembly {
    
    // Only one navigation should use in app
    static let navigation = NavigationService()
    
    func build() -> any NavigationServiceType {
        Self.navigation
    }
}
