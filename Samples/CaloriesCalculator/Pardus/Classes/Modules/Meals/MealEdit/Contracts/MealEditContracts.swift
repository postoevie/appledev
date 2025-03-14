//
//  MealEditContracts.swift
//  Pardus
//
//  Created by Igor Postoev on 18.5.24.
//  
//

import SwiftUI

// Router
protocol MealEditRouterProtocol: RouterProtocol {

    func returnBack()
    func showEditDish(dishId: UUID)
    func hidePicklist()
}

// Presenter
protocol MealEditPresenterProtocol: AnyObject, ObservableObject, PresenterProtocol {

    func didAppear()
    func doneTapped()
    func createDishTapped()
    func remove(dishId: UUID)
    func editDish(dishId: UUID)
}

// Interactor
protocol MealEditInteractorProtocol: InteractorProtocol {
    
    var mealId: UUID? { get  }
    var dishesFilter: Predicate? { get }
    
    func loadInitialMeal() async throws
    func performWithMeal(action: @escaping (Meal?) -> Void) async throws
    func performWithMealDishes(action: @escaping ([MealDish]) -> Void) async throws
    func createMealDish() async throws -> UUID
    func setSelectedDishes(_ dishesIds: Set<UUID>) async throws
    func remove(dishId: UUID) async throws
    func save() async throws
}

// ViewState
protocol MealEditViewStateProtocol: ObservableObject, ViewStateProtocol {
    
    var date: Date { get set }
    var error: String? { get set }
    var weight: String { get set }
    var sumKcals: String { get set }
    var sumProteins: String { get set }
    var sumFats: String { get set }
    var sumCarbs: String { get set }
    var dishItems: [MealDishesListItem] { get set }
}
