//
//  FLSingleValueCellToSectionAdapter.swift
//  FlexLayout
//
//  Created by Igor Postoev on 14.8.24..
//

final class FLSingleValueCellToSectionAdapter<Delegate: FLViewActionsDelegate,
                                              Router: FLCellSectionRouterProtocol,
                                              SectionId,
                                              ItemId: Initializable>: FLSingleValueViewDelegate where Delegate.SectionId == SectionId,
                                                                                                      Delegate.ItemId == ItemId {
    
    let sectionId: SectionId
    let sectionRouter: Router
    weak var actionsDelegate: Delegate?
    
    init(sectionId: SectionId,
         actionsDelegate: Delegate?,
         sectionRouter: Router) {
        self.sectionId = sectionId
        self.actionsDelegate = actionsDelegate
        self.sectionRouter = sectionRouter
    }
    
    func valueChanged(itemId: ItemId, value: FLValueDataType) {
        actionsDelegate?.valueOfInputInCellChanged(sectionId: sectionId,
                                                   itemId: itemId,
                                                   newValue: value)
    }
    
    func tappedValidationView(message: String, in view: UIView) {
        sectionRouter.showMessageView(text: message, sender: view)
    }
}

