//
//  MealParameterCell.swift
//  Pardus
//
//  Created by Igor Postoev on 18.11.24..
//

import SwiftUI

struct MealParameterCell: View {
    
    let title: LocalizedStringKey
    let value: String
    
    init(title: String, value: String) {
        self.title = LocalizedStringKey(title)
        self.value = value
    }
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .lineLimit(1)
                .font(.bodySmall2)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(value)
                .lineLimit(1)
                .font(.bodyRegular)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(8)
        .frame(maxWidth: .infinity)
        .background(.dishListCell)
        .foregroundStyle(Color(.white))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
