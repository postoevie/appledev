//
//  MealDishEditContracts.swift
//  Pardus
//
//  Created by Igor Postoev on 18.5.24.
//  
//

import SwiftUI

// Router
protocol MealDishEditRouterProtocol: RouterProtocol {

    func returnBack()
    func hidePicklist()
    func showMealIngridient(ingridientId: UUID)
}

// Presenter
protocol MealDishEditPresenterProtocol: AnyObject, ObservableObject, PresenterProtocol {

    func didAppear()
    func doneTapped()
    func submitDishValues()
    func createIngridientTapped()
    func removeIngridientTapped(ingridientId: UUID)
    func editIngridientTapped(ingridientId: UUID)
    func updateIngridientWeight(ingridientId: UUID)
}

// Interactor
protocol MealDishEditInteractorProtocol: InteractorProtocol {
    
    var mealDishId: UUID? { get  }
    var ingridientsFilter: Predicate? { get }
    
    func loadInitialMealDish() async throws
    func performWithMealDish(action: @escaping (MealDish?) -> Void) async throws
    func performWithIngridients(action: @escaping ([MealIngridient]) -> Void) async throws
    func setSelectedIngridients(_ dishesIds: Set<UUID>) async throws
    func remove(ingridientId: UUID) async throws
    func createMealIngridient() async throws -> UUID
    func save() async throws
}

// ViewState
protocol MealDishEditViewStateProtocol: ObservableObject, ViewStateProtocol {
    
    var error: String? { get set }
    var name: String { get set }
    var sumKcals: String { get set }
    var weight: String { get set }
    var sumProteins: String { get set }
    var sumFats: String { get set }
    var sumCarbs: String { get set }
    
    var ingridients: [MealDishesIngridientsListItem] { get set }
}
