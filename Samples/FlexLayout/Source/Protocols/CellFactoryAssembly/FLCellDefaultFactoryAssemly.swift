//
//  FLCellDefaultFactoryAssemly.swift
//  Pods
//
//  Created by Igor Postoev on 18.3.25..
//

public struct FLCellDefaultFactoryAssemly<SectionId,
                                          Delegate: FLViewActionsDelegate>: FLCellFactoryAssemly where Delegate.SectionId == SectionId,
                                                                                                       Delegate.ItemId: Hashable & Initializable {
    
    let sectionId: SectionId
    weak var actionsDelegate: Delegate?
    
    public init(sectionId: SectionId, actionsDelegate: Delegate? = nil) {
        self.actionsDelegate = actionsDelegate
        self.sectionId = sectionId
    }
    
    public func build(sectionId: SectionId, navigation: any FLNavigationProtocol) -> any FLCellAssemblyType {
        FLFlexViewCellDefaultAssembly(sectionId: sectionId,
                                      router: FLCellSectionRouter(navigation: navigation),
                                      actionsDelegate: actionsDelegate)
    }
}
