//
//  ViewsStateSnapshot.swift
//  Pardus
//
//  Created by Igor Postoev on 2.12.24..
//

struct ViewsStateSnapshot: Codable {
    
    var tab: Tabs
    
    var mealsItems: [Views]
    
    var dishesItems: [Views]
    
    var ingridientsItems: [Views]
}
