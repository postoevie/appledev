//
//  FLCellFactoryAssemly.swift
//  Pods
//
//  Created by Igor Postoev on 18.3.25..
//

public protocol FLCellFactoryAssemly<SectionId> {
    
    associatedtype SectionId
    
    func build(sectionId: SectionId, navigation: FLNavigationProtocol) -> FLCellAssemblyType
}
