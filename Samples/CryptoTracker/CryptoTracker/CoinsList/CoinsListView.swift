//
//  CoinsListView.swift
//  CryptoTracker
//
//  Created by Igor Postoev on 25.2.25..
//

import SwiftUI

struct CoinsListView<ViewModel: CoinsListViewModelType,
                     Presenter: CoinsListPresenterType>: View {
    
    @Environment(\.scenePhase) private var scenePhase
    
    @ObservedObject var viewModel: ViewModel
    @ObservedObject var presenter: Presenter
    
    var body: some View {
        List(viewModel.items, id: \.name) { item in
            HStack {
                Text(item.name)
                Spacer()
                Text(item.price)
            }
        }
        .padding()
        .onAppear {
            presenter.onAppear()
        }
        .onDisappear {
            presenter.onDisappear()
        }
        .onChange(of: scenePhase) { _, phase in
            switch phase {
            case .active: presenter.onAppear()
            case .background: presenter.onDisappear()
            default: break;
            }
        }
    }
}
