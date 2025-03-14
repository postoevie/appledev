//
//  ApplicationViewBuilder.swift
//  Pardus
//
//  Created by Igor Postoev on 11.5.24.
//  
//

import SwiftUI

final class ApplicationViewBuilder: Assembly, ObservableObject {
    
    required init(container: Container) {
        super.init(container: container)
    }
   
    // swiftlint:disable:next cyclomatic_complexity
    @ViewBuilder func build(view: Views) -> some View {
        switch view {
        case .mealsList:
            buildMealsList()
        case .mealEdit(let mealId):
            buildMealEdit(mealId)
        case .mealDishEdit(let mealDishId):
            buildMealDishEdit(mealDishId)
        case .mealIngridientEdit(ingridientId: let ingridientId):
            buildMealIngridientEdit(ingridientId)
        }
    }
    
    @ViewBuilder
    fileprivate func buildMealsList() -> some View {
        container.resolve(MealsListAssembly.self).build()
    }
    
    @ViewBuilder
    fileprivate func buildMealEdit(_ mealId: UUID?) -> some View {
        container.resolve(MealEditAssembly.self).build(mealId: mealId)
    }
    
    @ViewBuilder
    fileprivate func buildMealDishEdit(_ mealDishId: UUID?) -> some View {
        container.resolve(MealDishEditAssembly.self).build(mealDishId: mealDishId)
    }
    
    @ViewBuilder
    fileprivate func buildMealIngridientEdit(_ ingridientId: UUID?) -> some View {
        container.resolve(MealIngridientEditAssembly.self).build(ingridientId: ingridientId)
    }
}

extension ApplicationViewBuilder {
    
    func build(alert: Alerts?) -> Alert {
        switch alert {
        case .confirmAlert(let messageKey, let confirmAction, let cancelAction):
            Alert(title: Text(messageKey),
                  primaryButton: .destructive(Text("app.yes"), action: confirmAction),
                  secondaryButton: .default(Text("app.no"), action: cancelAction))
        case .errorAlert(let messageKey):
            Alert(title: Text(messageKey),
                  dismissButton: .default(Text("app.ok")) {
                let navigation = self.container.resolve(NavigationAssembly.self).build()
                navigation.alert = nil
            })
        case .none:
            {
                assertionFailure()
                return Alert(title: Text("app.invalidState"))
            }()
        }
    }
}

extension ApplicationViewBuilder {
    
    static var stub: ApplicationViewBuilder {
        return ApplicationViewBuilder(
            container: RootApp().container
        )
    }
}
