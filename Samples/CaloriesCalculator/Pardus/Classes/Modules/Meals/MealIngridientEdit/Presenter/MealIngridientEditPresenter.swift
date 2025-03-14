//
//  MealIngridientEditPresenter.swift
//  Pardus
//
//  Created by Igor Postoev on 2.6.24.
//
//

import Combine
import SwiftUI

final class MealIngridientEditPresenter: ObservableObject, MealIngridientEditPresenterProtocol {
  
    private let router: MealIngridientEditRouterProtocol
    private weak var viewState: MealIngridientEditViewState?
    private let interactor: MealIngridientEditInteractorProtocol
    
    var subscriptions: [AnyCancellable] = []
    
    init(router: MealIngridientEditRouterProtocol,
         interactor: MealIngridientEditInteractorProtocol,
         viewState: MealIngridientEditViewState) {
        self.router = router
        self.interactor = interactor
        self.viewState = viewState
    }
    
    func didAppear() {
        Task {
            try await interactor.loadIngridient()
            await updateViewState()
        }
    }
    
    func doneTapped() {
        Task {
            try await setAllValues()
            try await interactor.save()
            await MainActor.run {
                router.returnBack()
            }
        }
    }
    
    func submitValues() {
        Task {
            try await setAllValues()
            await updateViewState()
        }
    }
    
    private func setAllValues() async throws {
        guard let viewState else {
            return
        }
        await interactor.setName(viewState.name)
        await interactor.setWeight(Double(viewState.weight) ?? 0)
        await interactor.setCalories(Double(viewState.caloriesPer100) ?? 0)
        await interactor.setProteins(Double(viewState.proteinsPer100) ?? 0)
        await interactor.setFats(Double(viewState.fatsPer100) ?? 0)
        await interactor.setCarbs(Double(viewState.carbsPer100) ?? 0)
        try await interactor.save()
    }
    
    private func updateViewState() async {
        guard let viewState else {
            return
        }
        await MainActor.run {
            guard let data = interactor.data else {
                viewState.name = ""
                viewState.error = "errors.absendentity"
                return
            }
            viewState.name = data.name
            viewState.weight = String(data.weight)
            viewState.caloriesPer100 = String(data.caloriesPer100)
            viewState.proteinsPer100 = String(data.proteinsPer100)
            viewState.fatsPer100 = String(data.fatsPer100)
            viewState.carbsPer100 = String(data.carbsPer100)
            viewState.calories = String(data.calories)
            viewState.proteins = String(data.proteins)
            viewState.fats = String(data.fats)
            viewState.carbohydrates = String(data.carbohydrates)
            viewState.error = nil
        }
    }
}
