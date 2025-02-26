//
//  CoinsListPresenter.swift
//  CryptoTracker
//
//  Created by Igor Postoev on 25.2.25..
//

import Foundation
import Combine

struct CoinsListItem: Equatable {
    
    let name: String
    let price: String
}

struct CoinData: Equatable {
    
    let name: String
    let price: Double
}

enum NetworkError: Error {
    case httpFailed
    case parseFail
}

final class CoinsListPresenter: ObservableObject,
                                CoinsListPresenterType,
                                FetchCoinDataUseCaseResponder {
    
    weak var viewModel: (any CoinsListViewModelType)?

    private let fetchUseCase: FetchCoinsDataUseCaseType
    
    init(fetchUseCase: FetchCoinsDataUseCaseType) {
        self.fetchUseCase = fetchUseCase
    }
    
    func onAppear() {
        fetchUseCase.start()
    }
    
    func onDisappear() {
        fetchUseCase.cancel()
    }
    
    func coinsDataFetchUseCaseCompleted(data: [CoinData]) {
        Task {
            await MainActor.run {
                viewModel?.items = data
                    .sorted(by: { $0.name < $1.name })
                    .map { coin in
                        CoinsListItem(name: coin.name, price: String(coin.price))
                    }
            }
        }
    }
}

