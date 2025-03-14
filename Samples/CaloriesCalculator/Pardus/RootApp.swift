//
//  RootApp.swift
//  Pardus
//
//  Created by Igor Postoev on 11.5.24.
//  
//

import SwiftUI

@main
class RootApp: App {
    
    @ObservedObject var appViewBuilder: ApplicationViewBuilder
    
    let container: DependencyContainer = {
        let factory = AssemblyFactory()
        let container = DependencyContainer(assemblyFactory: factory)

        // Services
        container.apply(NavigationAssembly.self)
        container.apply(CoreDataStackServiceAssembly.self)
        container.apply(RecordsRestoreServiceAssembly.self)
        container.apply(MemoryPressureServiceAssembly.self)
        
        // Modules
        container.apply(RootAssembly.self)
        container.apply(MealsListAssembly.self)
        container.apply(MealEditAssembly.self)
        container.apply(MealDishEditAssembly.self)
        container.apply(MealIngridientEditAssembly.self)
        
        return container
    }()

    required init() {
        appViewBuilder = ApplicationViewBuilder(container: container)
    }
    
    var body: some Scene {
        WindowGroup {
            self.container.resolve(RootAssembly.self).build(appViewBuilder: self.appViewBuilder)
                .accessibilityIdentifier("pardus.root")
        }
    }
}
