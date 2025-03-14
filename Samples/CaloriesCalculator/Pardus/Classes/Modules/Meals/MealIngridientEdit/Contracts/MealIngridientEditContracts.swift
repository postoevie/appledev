//
//  MealIngridientEditContracts.swift
//  Pardus
//
//  Created by Igor Postoev on 2.6.24.
//  
//

import SwiftUI

// Router
protocol MealIngridientEditRouterProtocol: RouterProtocol {

    func returnBack()
}

// Presenter
protocol MealIngridientEditPresenterProtocol: PresenterProtocol, ObservableObject {

    func didAppear()
    func doneTapped()

    func submitValues()
}

// Interactor
protocol MealIngridientEditInteractorProtocol: InteractorProtocol {

    var ingridientId: UUID? { get }
    var data: MealIngridientEditData? { get }
    
    func loadIngridient() async throws
    func setName(_ name: String) async
    func setWeight(_ weight: Double) async
    func setCalories(_ calories: Double) async
    func setProteins(_ proteins: Double) async
    func setFats(_ fats: Double) async
    func setCarbs(_ carbs: Double) async
    func save() async throws
}

// ViewState
protocol MealIngridientEditViewStateProtocol: ViewStateProtocol, ObservableObject {
    var name: String { get set }
    var weight: String { get set }
    var caloriesPer100: String { get set }
    var proteinsPer100: String { get set }
    var fatsPer100: String { get set }
    var carbsPer100: String { get set }
    var calories: String { get set }
    var proteins: String { get set }
    var fats: String { get set }
    var carbohydrates: String { get set }
    var error: String? { get set }
}
