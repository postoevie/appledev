//
//  FieldSectionView.swift
//  Pardus
//
//  Created by Igor Postoev on 28.12.24..
//

import SwiftUI

struct FieldSectionView<Content: View>: View {
    
    var titleKey: LocalizedStringKey
    @ViewBuilder var content: () -> Content
    
    init(titleKey: String, content: @escaping () -> Content) {
        self.titleKey = LocalizedStringKey(titleKey)
        self.content = content
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(titleKey)
                    .font(.bodyLarge)
                    .foregroundStyle(.secondaryText)
                Spacer()
            }
            content()
        }
    }
}
