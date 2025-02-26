//
//  CoinsListViewModel.swift
//  CryptoTracker
//
//  Created by Igor Postoev on 25.2.25..
//

import Combine

final class CoinsListViewModel: ObservableObject, CoinsListViewModelType {
    
    @Published var items: [CoinsListItem] = []
}
