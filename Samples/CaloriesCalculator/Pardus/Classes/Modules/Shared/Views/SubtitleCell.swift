//
//  SubtitleCell.swift
//  Pardus
//
//  Created by Igor Postoev on 25.7.24..
//

import SwiftUI

struct SubtitleCell: View {
    
    let title: String
    let subtitle: String
    let badgeColor: Color
    let titleColor: Color
    let subtitleColor: Color
    let accessibilityId: String
    
    init(title: String,
         subtitle: String,
         badgeColor: Color = .clear,
         titleColor: Color = .primaryText,
         subtitleColor: Color = .secondaryText,
         accessibilityId: String = "") {
        self.title = title
        self.subtitle = subtitle
        self.badgeColor = badgeColor
        self.titleColor = titleColor
        self.subtitleColor = subtitleColor
        self.accessibilityId = accessibilityId
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .accessibilityIdentifier(accessibilityId + ".title")
                    .foregroundStyle(titleColor)
                    .font(.bodySmall)
                Circle()
                    .frame(width: Styles.listBadgeSize)
                    .foregroundStyle(badgeColor)
                Spacer()
            }
            Spacer()
                .frame(height: 12)
            HStack {
                Text(subtitle)
                    .accessibilityIdentifier(accessibilityId + ".subtitle")
                    .foregroundStyle(subtitleColor)
                    .font(.bodySmall2)
                Spacer()
            }
        }
    }
}
