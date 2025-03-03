//
//  CurrencyDatabaseService.swift
//  CryptoTracker
//
//  Created by Igor Postoev on 24.2.25..
//

import Foundation
import SwiftData

///  Actor gearantees mutex access. That allows to enqueue jobs and let it be taken by some thread in the pool.
///  Model Actor adds DefaultSerialModelExecutor making ModelContext access safe.
@ModelActor actor SaveCoinDataPersistService: CoinDataServiceLocalType {
 
    nonisolated func coinsDataFetchUseCaseCompleted(data: [CoinData]) {
        Task {
            // Actor is supposed to be run on a thread from the pool.
            try await save(coinItems: data)
        }
    }
    
    func getItems() throws -> [CoinData] {
        try modelContext
            .fetch(FetchDescriptor<Coin>())
            .map { CoinData(name: $0.name, price: $0.price) }
    }

    /// Updates (and creates if missing) database coin entities
    func save(coinItems: [CoinData]) throws {
        
        // Create coin if its absend in DB
        var createFetchDescriptor = FetchDescriptor<Coin>()
        createFetchDescriptor.propertiesToFetch = [\.name]
        let requestedCoins = Set(coinItems.map { $0.name })
        let existingCoins = try modelContext.fetch(createFetchDescriptor).map { $0.name }
        let absendCoins = requestedCoins.subtracting(existingCoins)
        for coinName in absendCoins {
            modelContext.insert(Coin(name: coinName, price: 0))
        }
        
        // Update all
        let coinItemsByNames = Dictionary(uniqueKeysWithValues: coinItems.map { ($0.name, $0) })
        var updateFetchDescriptor = FetchDescriptor<Coin>()
        let coinsToUpdate = Array(coinItemsByNames.keys)
        updateFetchDescriptor.predicate = #Predicate<Coin> { coinsToUpdate.contains($0.name) }
        try modelContext.enumerate(updateFetchDescriptor, allowEscapingMutations: true) { coin in
            guard let coinItem = coinItemsByNames[coin.name] else {
                return
            }
            coin.price = coinItem.price
        }
        
        // Persist
        try modelContext.save()
    }
}
