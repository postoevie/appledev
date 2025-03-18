//
//  FLTitledValueContentConfiguration.swift
//  FlexLayout
//
//  Created by Igor Postoev on 20.3.24..
//

struct FLTitledValueContentConfiguration<Delegate: FLSingleValueViewDelegate>: UIContentConfiguration, Equatable {
    
    weak var delegate: Delegate?
    
    let uid: Delegate.ItemId
    let data: FLSingleValueCellData
    let style: FLCellStyle
    let title: String?
    let validationErrorText: String?
    
    func makeContentView() -> UIView & UIContentView {
        FLTitledValueContentView<Delegate>(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> FLTitledValueContentConfiguration {
        self
    }
    
    static func == (lhs: FLTitledValueContentConfiguration, rhs: FLTitledValueContentConfiguration) -> Bool {
        lhs.data == rhs.data && lhs.style == rhs.style
    }
}

class FLEmptyContentView: NiblessView, UIContentView {
    
    var contentCofiguration: FLEmptyCellContentConfiguration
    
    init(contentCofiguration: FLEmptyCellContentConfiguration) {
        self.contentCofiguration = contentCofiguration
        super.init()
    }
    
    var configuration: any UIContentConfiguration {
        get {
            contentCofiguration
        }
        set {
            contentCofiguration = newValue as! FLEmptyCellContentConfiguration
        }
    }
}

struct FLEmptyCellContentConfiguration: UIContentConfiguration, Equatable {
    
    func makeContentView() -> any UIView & UIContentView {
        FLEmptyContentView(contentCofiguration: self)
    }
    
    func updated(for state: any UIConfigurationState) -> FLEmptyCellContentConfiguration {
        self
    }
}
