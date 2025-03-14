//
//  NavigationServiceType.swift
//  Pardus
//
//  Created by Igor Postoev on 11.5.24.
//
//

import Foundation
import Combine

protocol NavigationServiceType: ObservableObject, Identifiable {
    
    var tab: Tabs { get set }
    var mealsItems: [Views] { get set }
    var modalView: Views? { get set }
    var alert: Alerts? { get set }
    var sheetView: Views? { get set }
}
