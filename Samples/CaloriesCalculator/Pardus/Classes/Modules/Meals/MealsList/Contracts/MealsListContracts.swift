//
//  MealsListContracts.swift
//  Pardus
//
//  Created by Igor Postoev on 18.5.24.
//  
//

import SwiftUI

// Router
protocol MealsListRouterProtocol: RouterProtocol {
    
    func showAdd()
    func showEdit(mealId: UUID)
}

// Presenter
protocol MealsListPresenterProtocol: ObservableObject, PresenterProtocol {
    
    func tapAddNewItem()
    func tapToggleDateFilter()
    func setSeletedDate(_ date: Date)
    func didAppear()
    func deleteItem(uid: UUID)
    func tapItem(uid: UUID)
    func getFilterImageName() -> String
}

// Interactor
protocol MealsListInteractorProtocol: InteractorProtocol {
    var selectedDate: Date { get set }
    var dateFilterEnabled: Bool { get set }
    func loadMeals() async throws
    func performWithMeals(action: @escaping ([Meal]) -> Void) async throws
    func getDishes(for meal: Meal) -> [MealDish]
    func delete(itemId: UUID) async throws
}

// ViewState
protocol MealsListViewStateProtocol: ObservableObject, ViewStateProtocol {
    
    var selectedDate: Date { get set }
    var dateSelectionVisible: Bool { get set }
    var sections: [MealsListSection] { get }
    
    func set(sections: [MealsListSection])
    func setStartDateVisible(_ visible: Bool)
}
