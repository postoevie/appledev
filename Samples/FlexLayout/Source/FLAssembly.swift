//
//  FLAssembly.swift
//  FlexLayout
//
//  Created by Igor Postoev on 6.2.24..
//

/// Outcome of creation section views
public struct FLSectionViewResult {
    
    public let controller: UIViewController
    public let interaction: FLViewInteraction
}

typealias FLSectionViewBody = UIView & FLCellItemsContainer

public final class FLViewAssembly {
    
    weak var actionsDelegate: FLViewActionsDelegate?
    
    let sections: [FLSection]
    
    init(sections: [FLSection],
         actionsDelegate: FLViewActionsDelegate?) {
        self.sections = sections
        self.actionsDelegate = actionsDelegate
    }
    
    func build() -> [FLSectionViewResult] {
        sections.map { section in
            let sectionItem = section.sectionItem
            let sectionView = FLSectionView(accessKey: sectionItem.data.accessKey)
            let sectionController = FLSectionController { sectionView }
        
            let cellsAdapter = makeAdapter(sectionId: sectionItem.uid)
            cellsAdapter.actionsDelegate = actionsDelegate
            cellsAdapter.sectionRouter = FLCellSectionRouter(navigation: sectionController)
            
            let body = makeSectionViewBody(section: section, cellsAdapter: cellsAdapter)
            sectionView.set(body: body)
            
            let interaction = FLViewInteraction(itemsContainer: body)
            return FLSectionViewResult(controller: sectionController, interaction: interaction)
        }
    }
    
    private func makeSectionViewBody(section: FLSection,
                                     cellsAdapter: FLSingleValueCellToSectionAdapter) -> FLSectionViewBody {
        switch section.type {
        case .flexItems(let config):
            FLFlexItemsView(config: config,
                            items: section.cellItems,
                            accessKey: section.sectionItem.data.accessKey,
                            cellsAdapter: cellsAdapter,
                            style: section.sectionItem.style)
        }
    }
    
    private func makeAdapter(sectionId: UUID) -> FLSingleValueCellToSectionAdapter {
        FLSingleValueCellToSectionAdapter(sectionId: sectionId)
    }
}

