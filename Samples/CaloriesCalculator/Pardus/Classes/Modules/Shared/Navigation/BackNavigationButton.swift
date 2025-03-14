//
//  BackNavigationButton.swift
//  Pardus
//
//  Created by Igor Postoev on 26.12.24..
//

import SwiftUI

extension View {
    
    func withCustomBackButton(action: @escaping () -> Void) -> some View {
        modifier(BackButtonModifier(action: action))
    }
}

struct BackButtonModifier: ViewModifier {
    
    let action: () -> Void
    
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    BackButton(action: action)
                }
            }
    }
}

struct BackButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.backward.circle")
                .renderingMode(.template)
                .foregroundStyle(.primaryText)
        }
        .font(.title)
    }
}
