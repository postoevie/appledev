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
        let viewModel = CoinsListViewModel()
        
        let fetchUseCase = FetchCoinsDataUseCase(fireInterval: 3.0,
                                                 fetchService: FetchCoinDataNetworkService())
        
        let presenter = CoinsListPresenter(fetchUseCase: fetchUseCase)
        fetchUseCase.subscribe(presenter)
        
        // Opt for persisting data asyncronously with no dependency for UI updates.
        let saveService = SaveCoinDataPersistService(modelContainer: modelContainer)
        
        // Keep reference in subscription.
        fetchUseCase.subscribeStrong(saveService)
        
        presenter.viewModel = viewModel
        let view = CoinsListView(viewModel: viewModel,
                                 presenter: presenter).modelContainer(modelContainer)
        return view
    }
}
