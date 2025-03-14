//
//  MealEditPresenter.swift
//  Pardus
//
//  Created by Igor Postoev on 18.5.24.
//  
//

import SwiftUI
import Combine

final class MealEditPresenter: MealEditPresenterProtocol {
  
    private let router: MealEditRouterProtocol
    private weak var viewState: MealEditViewState?
    private let interactor: MealEditInteractorProtocol
    
    var subscriptions = [AnyCancellable]()
    
    init(router: MealEditRouterProtocol,
         interactor: MealEditInteractorProtocol,
         viewState: MealEditViewState) {
        self.router = router
        self.interactor = interactor
        self.viewState = viewState
    }
    
    func didAppear() {
        Task {
            try await interactor.loadInitialMeal()
            try await interactor.performWithMeal { meal in
                self.updateViewState(meal: meal)
            }
            try await interactor.performWithMealDishes { mealDishes in
                self.updateViewState(mealDishes: mealDishes)
            }
        }
    }
    
    func createDishTapped() {
        Task {
            try await submitValues()
            let dishId = try await interactor.createMealDish()
            await MainActor.run {
                router.showEditDish(dishId: dishId)
            }
        }
    }
    
    func editDish(dishId: UUID) {
        Task {
            try await submitValues()
            try await interactor.save()
            await MainActor.run {
                router.showEditDish(dishId: dishId)
            }
        }
    }
    
    func remove(dishId: UUID) {
        Task {
            try await interactor.remove(dishId: dishId)
            try await interactor.save()
            try await interactor.performWithMeal { meal in
                self.updateViewState(meal: meal)
            }
            try await interactor.performWithMealDishes { mealDishes in
                self.updateViewState(mealDishes: mealDishes)
            }
        }
    }
    
    func doneTapped() {
        Task {
            try await submitValues()
            try await interactor.save()
            await MainActor.run {
                router.returnBack()
            }
        }
    }
    
    private func submitValues() async throws {
        guard let viewState else {
            assertionFailure("Prerequsites not accomplished")
            return
        }
        try await interactor.performWithMeal { meal in
            meal?.date = viewState.date
        }
        try await self.interactor.save()
    }
    
    private func updateViewState(meal: Meal?) {
        guard let viewState = self.viewState else {
            return
        }
        guard let meal else {
            DispatchQueue.main.async {
                viewState.error = "errors.absendentity"
            }
            return
        }
        let mealDate = meal.date
        let weight = meal.weight
        let sumProteins = String(meal.proteins)
        let sumFats = String(meal.fats)
        let sumCarbs = String(meal.carbs)
        let sumKcals = String(meal.calories)
        
        DispatchQueue.main.async {
            viewState.error = nil
            viewState.date = mealDate
            viewState.weight = String(weight)
            viewState.sumProteins = String(sumProteins)
            viewState.sumFats = String(sumFats)
            viewState.sumCarbs = String(sumCarbs)
            viewState.sumKcals = String(sumKcals)
        }
    }
    
    private func updateViewState(mealDishes: [MealDish]) {
        guard let viewState = self.viewState else {
            return
        }
        let dishItems = mealDishes.map(self.mapToListItem)
        DispatchQueue.main.async {
            viewState.error = nil
            viewState.dishItems = dishItems
        }
    }
    
    private func mapToListItem(_ mealDish: MealDish) -> MealDishesListItem {
        let dish = mealDish.dish
        let formatter = Formatter.nutrients
        let weightString = formatter.string(for: mealDish.weight) ?? "0"
        let calString = formatter.string(for: mealDish.calories) ?? "0"
        let proteinsString = formatter.string(for: mealDish.proteins) ?? "0"
        let fatsString = formatter.string(for: mealDish.fats) ?? "0"
        let carbsString = formatter.string(for: mealDish.carbs) ?? "0"
        var categoryColor: Color = .clear
        if let colorHex = dish?.category?.colorHex,
           let color = try? UIColor.init(hex: colorHex) {
            categoryColor = Color(color)
        }
        let subtitle = "w: \(weightString) kcal: \(calString) p: \(proteinsString) f: \(fatsString) c: \(carbsString)"
        let item = MealDishesListItem(id: mealDish.id,
                                      title: mealDish.name,
                                      subtitle: subtitle,
                                      weight: NumberFormatter.nutrients.string(for: mealDish.weight) ?? "0",
                                      categoryColor: categoryColor)
        return item
    }
}
