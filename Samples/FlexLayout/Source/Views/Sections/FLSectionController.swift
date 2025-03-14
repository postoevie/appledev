//
//  FLSectionController.swift
//  FlexLayout
//
//  Created by Igor Postoev on 6.3.24..
//

final class FLSectionController: NiblessViewController {
    
    private let makeView: () -> UIView
    
    init(makeView: @escaping () -> UIView) {
        self.makeView = makeView
        super.init()
    }
    
    override func loadView() {
        view = makeView()
    }
}
