//
//  AppTypography.swift
//  Pardus
//
//  Created by Igor Postoev on 23.11.24..
//

import SwiftUI

extension Font {
    
    static let titleRegular = AppTypography.Body.large
    static let bodyLarge = AppTypography.Body.large
    static let bodyRegular = AppTypography.Body.regular
    static let bodySmall = AppTypography.Body.small
    static let bodySmall2 = AppTypography.Body.small2
    static let icon = AppTypography.Icon.icon
    static let icon2 = AppTypography.Icon.icon2
    static let keyboard = Font.body
}

private struct AppTypography {
    
    struct Title {
        
        static let regular = Font.custom("RussoOne", size: 24, relativeTo: .title)
    }
    
    struct Body {
        
        static let large = Font.custom("RussoOne", size: 20, relativeTo: .body)
        static let regular = Font.custom("RussoOne", size: 16, relativeTo: .body)
        static let small = Font.custom("RussoOne", size: 16, relativeTo: .body)
        static let small2 = Font.custom("RussoOne", size: 12, relativeTo: .body)
    }
    
    struct Icon {
        
        static let icon = Font.title
        static let icon2 = Font.title2
    }
}
