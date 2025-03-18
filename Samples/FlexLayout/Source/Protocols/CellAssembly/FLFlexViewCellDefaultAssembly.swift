//
//  FLFlexViewCellDefaultAssembly.swift
//  Pods
//
//  Created by Igor Postoev on 18.3.25..
//


public struct FLFlexViewCellDefaultAssembly<SectionId,
                                            ItemId: Hashable & Initializable,
                                            Delegate: FLViewActionsDelegate,
                                            Router: FLCellSectionRouterProtocol>: FLCellAssemblyType where Delegate.SectionId == SectionId,
                                                                                                           Delegate.ItemId == ItemId {
    
    let sectionId: SectionId
    let router: Router
    
    weak var actionsDelegate: Delegate?
    
    public func buildContentConfig(item: any FLCellItemType) -> UIContentConfiguration {
        guard let item = item as? FLCellItem<ItemId> else {
            assertionFailure("The assembly works only with FLCellItem")
            return FLEmptyCellContentConfiguration()
        }
        switch item.data {
        case .titledSingleValue(let dataItem, let title, let validationText):
            let cellAdapter = FLSingleValueCellToSectionAdapter(sectionId: sectionId,
                                                                actionsDelegate: actionsDelegate,
                                                                sectionRouter: router)
            return FLTitledValueContentConfiguration(delegate: cellAdapter,
                                                     uid: item.uid,
                                                     data: dataItem,
                                                     style: item.style,
                                                     title: title,
                                                     validationErrorText: validationText)
        case .empty:
            return FLEmptyCellContentConfiguration()
        }
    }
    
    public func buildBackgroundConfig(item: any FLCellItemType) -> UIBackgroundConfiguration {
        guard let item = item as? FLCellItem<ItemId> else {
            assertionFailure("The assembly works only with FLCellItem")
            return UIBackgroundConfiguration.listGroupedCell()
        }
        switch item.data {
        case .titledSingleValue(_, _, let validationText):
            var configuration = UIBackgroundConfiguration.listGroupedCell()
            configuration.backgroundColor = item.style.backgroundColor
            configuration.cornerRadius = 8
            if validationText != nil {
                configuration.strokeWidth = 2
                configuration.strokeColor = item.style.validationColor
            }
            return configuration
        case .empty:
            return UIBackgroundConfiguration.listGroupedCell()
        }
    }
}
