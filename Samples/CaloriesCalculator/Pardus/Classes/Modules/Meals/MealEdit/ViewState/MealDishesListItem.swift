//
//  MealDishesListItem.swift
//  Pardus
//
//  Created by Igor Postoev on 16.10.24..
//

import SwiftUI

struct MealDishesListItem: Identifiable {
    
    let id: UUID
    let title: String
    let subtitle: String
    let weight: String
    let categoryColor: Color
}
