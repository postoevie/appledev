//
//  MealsListViewState.swift
//  Pardus
//
//  Created by Igor Postoev on 18.5.24.
//
//

import SwiftUI
import Combine

final class MealsListViewState: ObservableObject, MealsListViewStateProtocol {
    
    @Published var sections: [MealsListSection] = []
    @Published var selectedDate: Date = Date()
    @Published var dateSelectionVisible: Bool = false
    
    private var presenter: (any MealsListPresenterProtocol)?
    private var subscriptions: [AnyCancellable] = []
    
    func set(sections: [MealsListSection]) {
        self.sections = sections
    }
    
    func set(presenter: (any MealsListPresenterProtocol)?) {
        guard self.presenter == nil else {
            assertionFailure("Set presenter once")
            return
        }
        self.presenter = presenter
        $selectedDate
            .sink {
                self.presenter?.setSeletedDate($0)
            }.store(in: &subscriptions)
    }
    
    func setStartDateVisible(_ visible: Bool) {
        dateSelectionVisible = visible
    }
}

struct MealsListSection {
    
    let title: String
    let items: [MealsListItem]
}

struct MealsListItem: Identifiable {
    
    let id: UUID
    let title: String
    let subtitle: String
}
