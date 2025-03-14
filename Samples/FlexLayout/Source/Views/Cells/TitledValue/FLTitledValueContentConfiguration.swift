//
//  FLTitledValueContentConfiguration.swift
//  FlexLayout
//
//  Created by Igor Postoev on 20.3.24..
//

struct FLTitledValueContentConfiguration: UIContentConfiguration, Equatable {
    
    weak var delegate: FLSingleValueViewDelegate?
    
    let uid: UUID
    let data: FLSingleValueCellData
    let style: FLCellStyle
    
    func makeContentView() -> UIView & UIContentView {
        FLTitledValueContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> FLTitledValueContentConfiguration {
        self
    }
    
    static func == (lhs: FLTitledValueContentConfiguration, rhs: FLTitledValueContentConfiguration) -> Bool {
        lhs.data == rhs.data && lhs.style == rhs.style
    }
}
