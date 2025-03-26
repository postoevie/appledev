//
//  CoinsListViewWithSwiftData.swift
//  CryptoTracker
//
//  Created by Igor Postoev on 4.3.25..
//

import SwiftUI
import SwiftData

struct CoinsListViewWithSwiftData: View {
    
    @Environment(\.scenePhase) private var scenePhase
    
    @Query(sort: \Coin.name) private var coins: [Coin]
    
    var fetchUseCase: FetchCoinsDataUseCase
    
    var body: some View {
        VStack {
            List(coins, id: \.name) { item in
                HStack {
                    Text(item.name)
                    Spacer()
                    Text(String(item.price))
                }
            }
            HStack {
                Button("") {
                    fetchUseCase.cancel()
                }
                Button("Stop timer") {
                    fetchUseCase.cancel()
                }
            }
        }
        .onAppear {
            fetchUseCase.start()
        }
        .onDisappear {
            fetchUseCase.cancel()
        }
        .onChange(of: scenePhase) { _, phase in
            switch phase {
            case .active: fetchUseCase.start()
            case .background: fetchUseCase.cancel()
            default: break;
            }
        }
    }
}

