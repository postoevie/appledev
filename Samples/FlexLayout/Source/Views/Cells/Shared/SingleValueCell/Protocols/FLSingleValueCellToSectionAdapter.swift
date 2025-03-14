//
//  FLSingleValueCellToSectionAdapter.swift
//  FlexLayout
//
//  Created by Igor Postoev on 14.8.24..
//

final class FLSingleValueCellToSectionAdapter: FLSingleValueViewDelegate {
    
    var sectionRouter: FLCellSectionRouterProtocol?
    weak var actionsDelegate: FLViewActionsDelegate?
    
    private let sectionId: UUID
    
    init(sectionId: UUID) {
        self.sectionId = sectionId
    }
    
    func valueChanged(itemId: UUID, value: FLValueDataType) {
        actionsDelegate?.valueOfInputInCellChanged(sectionId: sectionId,
                                                   itemId: itemId,
                                                   newValue: value)
    }
    
    func tappedValidationView(message: String, in view: UIView) {
        sectionRouter?.showMessageView(text: message, sender: view)
    }
}

