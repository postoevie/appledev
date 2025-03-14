//
//  MealsListPresenter.swift
//  Pardus
//
//  Created by Igor Postoev on 18.5.24.
//
//

import SwiftUI

final class MealsListPresenter: ObservableObject, MealsListPresenterProtocol {
    
    private let router: MealsListRouterProtocol
    private let interactor: MealsListInteractorProtocol
    private weak var viewState: (any MealsListViewStateProtocol)?
    
    let sectionDateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    let itemDateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
    
    init(router: MealsListRouterProtocol,
         interactor: MealsListInteractorProtocol,
         viewState: (any MealsListViewStateProtocol)?) {
        self.router = router
        self.interactor = interactor
        self.viewState = viewState
    }
    
    func tapToggleDateFilter() {
        interactor.dateFilterEnabled.toggle()
        viewState?.setStartDateVisible(interactor.dateFilterEnabled)
        updateViewState()
    }
    
    func setSeletedDate(_ date: Date) {
        interactor.selectedDate = date
        updateViewState()
    }
    
    func tapAddNewItem() {
        router.showAdd()
    }
    
    func deleteItem(uid: UUID) {
        Task {
            do {
                try await interactor.delete(itemId: uid)
                updateViewState()
            } catch {
                print(error)
            }
        }
    }
    
    func tapItem(uid: UUID) {
        router.showEdit(mealId: uid)
    }
    
    func didAppear() {
        Task {
            try await interactor.loadMeals()
            updateViewState()
        }
    }
    
    func getFilterImageName() -> String {
        let dateSelectionVisible = viewState?.dateSelectionVisible == true
        return dateSelectionVisible ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle"
    }
    
    private func updateViewState() {
        Task {
            try await interactor.performWithMeals { meals in
                let sections = self.makeSortedSections(meals: meals)
                DispatchQueue.main.async {
                    self.viewState?.set(sections: sections)
                }
            }
        }
    }
    
    private func makeSortedSections(meals: [Meal]) -> [MealsListSection] {
        let sortedMeals = meals.sorted { $0.date > $1.date }
        var sections = [MealsListSection]()
        for meal in sortedMeals {
            let date = meal.date
            let dateString = sectionDateFormatter.string(from: date)
            if let lastSection = sections.last,
               dateString == lastSection.title {
                _ = sections.removeLast()
                sections.append(MealsListSection(title: dateString,
                                                 items: lastSection.items + [mapToItem(meal: meal)]))
                continue
            }
            sections.append(MealsListSection(title: dateString,
                                             items: [mapToItem(meal: meal)]))
        }
        return sections
    }
    
    private func mapToItem(meal: Meal) -> MealsListItem {
        let mealDishes = interactor.getDishes(for: meal)
        return MealsListItem(id: meal.id,
                             title: itemDateFormatter.string(from: meal.date),
                             subtitle: mealDishes.map { $0.name }.joined(separator: ", "))
    }
}
