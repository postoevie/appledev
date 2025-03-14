//
//  OnlyTitleCell.swift
//  Pardus
//
//  Created by Igor Postoev on 25.7.24..
//

import SwiftUI

struct OnlyTitleCell: View {
    
    let title: String
    let color: Color
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .foregroundStyle(.primaryText)
                    .font(.bodySmall)
                Circle()
                    .frame(width: Styles.listBadgeSize)
                    .foregroundStyle(color)
                Spacer()
            }
        }
    }
}
