//
//  CoinsDataFetchUseCase.swift
//  CryptoTracker
//
//  Created by Igor Postoev on 25.2.25..
//

import Combine

protocol CoinsListViewModelType: ObservableObject {
    
    var items: [CoinsListItem] { get set }
}

protocol CoinsListPresenterType: ObservableObject {
    
    func onAppear()
    func onDisappear()
}

/// A piece of the user story
protocol UseCaseType {
    
    func start()
}

/// Use case of fetching coins data
protocol FetchCoinsDataUseCaseType: UseCaseType {
    
    /// Cancels fetching process
    func cancel()
}
 
protocol FetchCoinDataUseCaseResponder: AnyObject {
    
    /// Called when fetching is completed
    /// - Parameter data: Fetched data
    func coinsDataFetchUseCaseCompleted(data: [CoinData])
}

protocol CoinDataServiceRemoteType {
    
    func fetchCoinsList() async throws -> [String]
    func fetchCoinPrice(coinName: String) async throws -> Double
}

protocol CoinDataServiceLocalType {
    
    func save(coinItems: [CoinData]) async throws
    func getItems() async throws -> [CoinData]
}
