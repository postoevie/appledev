//
//  NavigationService.swift
//  Pardus
//
//  Created by Igor Postoev on 11.5.24.
//
//

import SwiftUI
import Combine

public class NavigationService: NavigationServiceType, ObservableObject, Identifiable {
    
    public let id = UUID()
    
    public static func == (lhs: NavigationService, rhs: NavigationService) -> Bool {
        lhs.id == rhs.id
    }
    
    @Published var tab: Tabs = .meals
    @Published var mealsItems: [Views] = [.mealsList]
    
    @Published var sheetView: Views?
    @Published var modalView: Views?
    @Published var alert: Alerts?
}

enum Tabs: Hashable, Codable {
    
    case meals
}

enum Views: Codable, Equatable, Hashable {
    
    // Explicitly implement encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(makeCode())
    }
    
    // Explicitly implement decoding
    // swiftlint:disable:next cyclomatic_complexity
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self = switch try container.decode(Codes.self) {
        case .mealsList:
                .mealsList
        case .mealEdit(let mealId):
                .mealEdit(mealId: mealId)
        case .mealDishEdit(let mealDishId):
                .mealDishEdit(mealDishId: mealDishId)
        case .mealIngridientEdit(ingridientId: let ingridientId):
                .mealIngridientEdit(ingridientId: ingridientId)
        }
    }
    
    // swiftlint:disable:next cyclomatic_complexity
    private func makeCode() -> Codes {
        switch self {
        case .mealsList:
            Codes.mealsList
        case .mealEdit(let mealId):
            Codes.mealEdit(mealId: mealId)
        case .mealDishEdit(let mealDishId):
            Codes.mealDishEdit(mealDishId: mealDishId)
        case .mealIngridientEdit(ingridientId: let ingridientId):
            Codes.mealIngridientEdit(ingridientId: ingridientId)
        }
    }
    
     enum Codes: Codable, Hashable {
         case mealsList
         case mealEdit(mealId: UUID?)
         case mealDishEdit(mealDishId: UUID?)
         case mealIngridientEdit(ingridientId: UUID?)
     }
    
    static func == (lhs: Views, rhs: Views) -> Bool {
        lhs.makeCode() == rhs.makeCode()
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(makeCode())
    }
    
    case mealsList
    case mealEdit(mealId: UUID?)
    case mealDishEdit(mealDishId: UUID?)
    case mealIngridientEdit(ingridientId: UUID?)
    
    var stringKey: String {
        switch self {
        case .mealsList:
            "mealsList"
        case .mealEdit:
            "mealEdit"
        case .mealDishEdit:
            "mealDishEdit"
        case .mealIngridientEdit:
            "mealIngridientEdit"
        }
    }
    
    func isTypeIn(_ views: [Views]) -> Bool {
        views.contains(where: { $0.stringKey == stringKey })
    }
}

enum Alerts: Equatable, Hashable {
    static func == (lhs: Alerts, rhs: Alerts) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .confirmAlert:
            hasher.combine("confirmAlert")
        case .errorAlert:
            hasher.combine("errorAlert")
        }
    }
    
    case confirmAlert(messageKey: String, confirmAction: (() -> Void)?, cancelAction: (() -> Void)?)
    case errorAlert(messageKey: String)
}
