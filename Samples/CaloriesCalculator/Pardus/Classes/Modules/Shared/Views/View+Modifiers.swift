//
//  Views+Modifiers.swift
//  Pardus
//
//  Created by Igor Postoev on 11.8.24..
//

import SwiftUI

extension View {
    
    func defaultCellInsets() -> some View {
        modifier(DefaultCellInsets())
    }
}

private struct DefaultCellInsets: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .listRowInsets(.init(top: 8,
                                 leading: 8,
                                 bottom: 8,
                                 trailing: 0))
    }
}

extension View {
    
    func defaultTextField() -> some View {
        modifier(DefaultTextField())
    }
    
    func numericTextField() -> some View {
        modifier(NumbericTextField())
    }
}

private struct DefaultTextField: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.bodySmall)
            .submitLabel(.return)
            .textFieldStyle(.roundedBorder)
    }
}

private struct NumbericTextField: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.bodySmall)
            .submitLabel(.return)
            .textFieldStyle(.roundedBorder)
            .keyboardType(.decimalPad)
    }
}
