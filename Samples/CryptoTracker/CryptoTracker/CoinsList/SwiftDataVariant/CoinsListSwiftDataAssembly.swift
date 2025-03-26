//
//  CoinsListSwiftDataAssembly.swift
//  CryptoTracker
//
//  Created by Igor Postoev on 4.3.25..
//

import SwiftUI
import SwiftData

@MainActor
struct CoinsListSwiftDataAssembly {
    
    func build(modelContainer: ModelContainer) -> some View {
        let networkService = NetworkAvailabilityService()
        let fetchUseCase = FetchCoinsDataUseCase(tickInterval: 5.0,
                                                 remoteDataService: FetchCoinDataNetworkService(),
                                                 localDataService: CoinDataPersistService(modelContainer: modelContainer),
                                                 networkAvailabilityService: networkService)
        networkService.subscribe(fetchUseCase)

        let view = CoinsListViewWithSwiftData(fetchUseCase: fetchUseCase).modelContainer(modelContainer)
        
        return view
    }
}
