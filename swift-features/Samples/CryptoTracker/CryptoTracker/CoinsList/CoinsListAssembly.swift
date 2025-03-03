//
//  CoinsListAssembly.swift
//  CryptoTracker
//
//  Created by Igor Postoev on 24.2.25..
//

import SwiftData
import SwiftUI

struct CoinsListAssembly {
    
    func build(modelContainer: ModelContainer) -> some View {
        let networkService = NetworkAvailabilityService()
        
        let fetchUseCase = FetchCoinsDataUseCase(tickInterval: 5.0,
                                                 remoteDataService: FetchCoinDataNetworkService(),
                                                 localDataService: SaveCoinDataPersistService(modelContainer: modelContainer),
                                                 networkAvailabilityService: networkService)
        networkService.subscribe(fetchUseCase)
        
        // Opt for persisting data asyncronously with no dependency for UI updates.
        // Keep reference in subscription.
        let presenter = CoinsListPresenter(fetchUseCase: fetchUseCase)
        fetchUseCase.subscribe(presenter)
        
        let viewModel = CoinsListViewModel()
        presenter.viewModel = viewModel
        
        let view = CoinsListView(viewModel: viewModel,
                                 presenter: presenter).modelContainer(modelContainer)
        return view
    }
}
