//
//  FLAssembly.swift
//  FlexLayout
//
//  Created by Igor Postoev on 6.2.24..
//

public final class FLAssembly<SectionId, ItemId> {
    
    private let sections: [FLSection<SectionId, ItemId>]
    
    public init(sections: [FLSection<SectionId, ItemId>]) {
        self.sections = sections
    }
    
    public func build() -> [FLSectionViewResult<ItemId>] {
        sections.map(mapToResult)
    }
    
    private func mapToResult(section: FLSection<SectionId, ItemId>) -> FLSectionViewResult<ItemId> {
        let sectionItem = section.sectionItem
        let sectionView = FLSectionView(accessKey: sectionItem.data.accessKey)
        let sectionController = FLSectionController { sectionView }
        
        let cellFactoryAssembly = section.cellFactoryAssembly
        let sectionAssembly = section.sectionAssembly
        
        let cellAssebly = cellFactoryAssembly.build(sectionId: sectionItem.uid, navigation: sectionController)
        let (body, itemsContainer) = sectionAssembly.build(cellAssembly: cellAssebly)
        
        sectionView.set(body: body)
        
        let interaction = FLViewInteraction(itemsContainer: itemsContainer)
        return FLSectionViewResult(controller: sectionController, interaction: interaction)
    }
}
