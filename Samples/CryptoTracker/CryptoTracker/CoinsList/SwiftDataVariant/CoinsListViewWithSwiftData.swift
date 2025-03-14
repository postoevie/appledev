//
//  CoinsListViewWithSwiftData.swift
//  CryptoTracker
//
//  Created by Igor Postoev on 4.3.25..
//

import SwiftUI
import SwiftData

struct CoinsListViewWithSwiftData: View {
    
    @Query(sort: \Coin.name) private var coins: [Coin]
    
    let fetchUseCase: FetchCoinsDataUseCase
    
    var body: some View {
        List(coins, id: \.name) { item in
            HStack {
                Text(item.name)
                Spacer()
                Text(String(item.price))
            }
        }
        .onAppear {
            fetchUseCase.start()
        }
        .onDisappear {
            fetchUseCase.cancel()
        }
    }
}

