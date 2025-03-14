//
//  RootView.swift
//  Pardus
//
//  Created by Igor Postoev on 11.5.24.
//
//

import SwiftUI

struct RootView: View {
    
    @ObservedObject var navigationService: NavigationService
    @ObservedObject var appViewBuilder: ApplicationViewBuilder
    @ObservedObject var presenter: RootPresenter
    
    var body: some View {
        TabView(selection: $navigationService.tab) {
            NavigationStack(path: $navigationService.mealsItems) {
                Spacer()
                    .navigationDestination(for: Views.self) { path in
                        appViewBuilder.build(view: path)
                            .padding(Styles.defaultAppPadding)
                            .navigationBarBackButtonHidden(true)
                    }
            }
            .tabItem {
                Label("rootview.tabs.meals", systemImage: "fork.knife")
            }
            .tag(Tabs.meals)
        }
        .onAppear {
            presenter.onAppear()
        }
        .fullScreenCover(isPresented: .constant($navigationService.modalView.wrappedValue != nil)) {
            if let modal = navigationService.modalView {
                appViewBuilder.build(view: modal)
            }
        }
        .sheet(isPresented: .constant($navigationService.sheetView.wrappedValue != nil),
               onDismiss: {
            navigationService.sheetView = nil
        },
               content: {
            if let sheet = navigationService.sheetView {
                appViewBuilder.build(view: sheet)
            }
        })
        .alert(isPresented: .constant($navigationService.alert.wrappedValue != nil)) {
            appViewBuilder.build(alert: navigationService.alert)
        }
    }
}

struct RootViewPreviews: PreviewProvider {
    
    static let viewBuilder: ApplicationViewBuilder = {
        let container = RootApp().container
        return ApplicationViewBuilder(container: container)
    }()
    
    static var container: Container {
        viewBuilder.container
    }
    
    static var previews: some View {
        container.resolve(RootAssembly.self).build(appViewBuilder: viewBuilder)
    }
}
