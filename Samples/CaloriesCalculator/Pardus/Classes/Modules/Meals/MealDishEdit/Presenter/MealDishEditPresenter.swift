//
//  MealEditPresenter.swift
//  Pardus
//
//  Created by Igor Postoev on 18.5.24.
//  
//

import SwiftUI
import Combine

final class MealDishEditPresenter: MealDishEditPresenterProtocol {
    
    private let router: MealDishEditRouterProtocol
    private let interactor: MealDishEditInteractorProtocol
    private weak var viewState: (any MealDishEditViewStateProtocol)?
    
    var subscriptions = [AnyCancellable]()
    
    init(router: MealDishEditRouterProtocol,
         interactor: MealDishEditInteractorProtocol,
         viewState: (any MealDishEditViewStateProtocol)?) {
        self.router = router
        self.interactor = interactor
        self.viewState = viewState
    }
    
    func didAppear() {
        Task {
            try await interactor.loadInitialMealDish()
            try await interactor.performWithMealDish { mealDish in
                self.updateViewState(mealDish: mealDish)
            }
            try await interactor.performWithIngridients { ingridients in
                self.updateViewState(mealIngridients: ingridients)
            }
        }
    }
    
    func submitDishValues() {
        Task {
            try await saveMealDishValues()
        }
    }

    func updateIngridientWeight(ingridientId: UUID) {
        guard let viewState,
              let ingridient = viewState.ingridients.first(where: { $0.id == ingridientId }) else {
            return
        }
        Task {
            let weightString = ingridient.weight
            let weight: NSNumber = NumberFormatter.nutrients.number(from: weightString) ?? .init(value: 0)
            try await interactor.performWithMealDish { mealDish in
                let ingiridient = mealDish?.ingridients[ingridientId]
                ingiridient?.weight = weight.doubleValue
                self.updateViewState(mealDish: mealDish)
            }
            try await interactor.performWithIngridients { ingridients in
                self.updateViewState(mealIngridients: ingridients)
            }
        }
    }
    
    func createIngridientTapped() {
        Task {
            try await saveMealDishValues()
            let ingridientId = try await interactor.createMealIngridient()
            try await interactor.save()
            await MainActor.run {
                router.showMealIngridient(ingridientId: ingridientId)
            }
        }
    }
    
    func removeIngridientTapped(ingridientId: UUID) {
        Task {
            try await interactor.remove(ingridientId: ingridientId)
            try await interactor.save()
            try await interactor.performWithMealDish { mealDish in
                self.updateViewState(mealDish: mealDish)
            }
            try await interactor.performWithIngridients { ingridients in
                self.updateViewState(mealIngridients: ingridients)
            }
        }
    }
    
    func editIngridientTapped(ingridientId: UUID) {
        router.showMealIngridient(ingridientId: ingridientId)
    }

    func doneTapped() {
        Task {
            try await interactor.save()
            await MainActor.run {
                router.returnBack()
            }
        }
    }
    
    private func updateViewState(mealDish: MealDish?) {
        guard let viewState = self.viewState else {
            return
        }
        guard let mealDish else {
            DispatchQueue.main.async {
                viewState.error = "errors.absendentity"
            }
            return
        }
        
        let name = String(mealDish.name)
        let sumKcals = String(mealDish.calories)
        let weight = String(mealDish.weight)
        let sumProteins = String(mealDish.proteins)
        let sumFats = String(mealDish.fats)
        let sumCarbs = String(mealDish.carbs)
        
        DispatchQueue.main.async {
            viewState.error = nil
            viewState.name = name
            viewState.weight = String(weight)
            viewState.sumKcals = String(sumKcals)
            viewState.sumProteins = String(sumProteins)
            viewState.sumFats = String(sumFats)
            viewState.sumCarbs = String(sumCarbs)
        }
    }
    
    private func saveMealDishValues() async throws {
        guard let viewState else {
            return
        }
        try await interactor.performWithMealDish { mealDish in
            mealDish?.name = viewState.name
        }
        try await interactor.save()
    }
    
    private func updateViewState(mealIngridients: [MealIngridient]) {
        guard let viewState = self.viewState else {
            return
        }
        let ingridients = mealIngridients.map(self.mapToListItem)
        DispatchQueue.main.async {
            viewState.ingridients = ingridients
        }
    }
    
    private func mapToListItem(_ ingridient: MealIngridient) -> MealDishesIngridientsListItem {
        let formatter = Formatter.nutrients
        let calString = formatter.string(for: ingridient.calories) ?? "0"
        let proteinsString = formatter.string(for: ingridient.proteins) ?? "0"
        let fatsString = formatter.string(for: ingridient.fats) ?? "0"
        let carbsString = formatter.string(for: ingridient.carbs) ?? "0"
        var categoryColor: Color = .clear
        if let colorHex = ingridient.ingridient?.category?.colorHex,
           let color = try? UIColor.init(hex: colorHex) {
            categoryColor = Color(color)
        }
        let subtitle = "\(calString) kcal \(proteinsString)/\(fatsString)/\(carbsString)"
        let weightString = NumberFormatter.nutrients.string(for: ingridient.weight) ?? "0"
        let item = MealDishesIngridientsListItem(id: ingridient.id,
                                                 title: ingridient.name,
                                                 subtitle: subtitle,
                                                 weight: weightString,
                                                 categoryColor: categoryColor)
        return item
    }
}
