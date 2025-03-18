//
//  FieldsPresenter.swift
//  Sample
//
//  Created by Igor Postoev on 20.3.24..
//

import FlexLayout

protocol FlexItemsSettingsProviderProtocol {
    
    func getSettingFields() -> [String]
    func isReadonly(field: String) -> Bool
    func getParameter(key: String) -> String?
}

protocol FlexItemsDataServiceProtocol {
    
    func getTitle(field: String) -> String?
    func getValue(field: String) -> FLValueDataType
    func setValue(field: String, value: FLValueDataType)
    func getErrorText(field: String) -> String?
}

extension UUID: @retroactive Initializable { } // https://github.com/swiftlang/swift-evolution/blob/main/proposals/0364-retroactive-conformance-warning.md

class FlexItemsPresenter: FLViewActionsDelegate {
    
    var interaction: FLViewInteraction<UUID>?
    var fieldsByIds = [UUID: String]()
    
    private let settingsProvider: FlexItemsSettingsProviderProtocol
    private let dataService: FlexItemsDataServiceProtocol
    
    init(settingsProvider: FlexItemsSettingsProviderProtocol,
         dataService: FlexItemsDataServiceProtocol) {
        self.settingsProvider = settingsProvider
        self.dataService = dataService
        fillfieldsByIds()
    }
    
    func createSections() -> [FLSection<UUID, UUID>] {
        let ratios = getRatios()
        let config = FLFlexItemsConfig(ratios: ratios, rowHeight: 100)
        
        let sectionItem = createSectionItem()
        let cellItems = createCellItems()
        let itemIds = cellItems.map { $0.uid }
        let itemsByIds = Dictionary.init(uniqueKeysWithValues: cellItems.map { ($0.uid, $0) })
        
        let section = FLSection(sectionItem: sectionItem,
                                sectionAssembly: FLFlexViewAssembly<UUID>(itemIds: itemIds,
                                                                       itemsByIds: itemsByIds,
                                                                       config: config,
                                                                       style: sectionItem.style,
                                                                       accessKey: "flexItems.sectionView"),
                                cellFactoryAssembly: FLCellDefaultFactoryAssemly(sectionId: sectionItem.uid,
                                                                                 actionsDelegate: self))
        return [section]
    }
    
    private func createSectionItem() -> FLSectionItem<UUID> {
        let sectionItem = FLSectionItem(uid: UUID(),
                                        data: FLSectionData(title: "Report"),
                                        style: FLSectionStyle())
        return sectionItem
    }
    
    private func fillfieldsByIds() {
        for field in settingsProvider.getSettingFields() {
            fieldsByIds[UUID()] = field
        }
    }
    
    private func getRatios() -> [RatioValue] {
        let fields = settingsProvider.getSettingFields()
        let ratiosString = settingsProvider.getParameter(key: "ratios")
        var ratioFloats = [Float]()
        if let ratiosString {
            ratioFloats = ratiosString.components(separatedBy: ",").compactMap { ratio in
                guard let float = Float(ratio) else {
                    return nil
                }
                return float / 100
            }
        }
        if ratioFloats.count == 0 || ratioFloats.count != fields.count {
            ratioFloats = fields.map { _ in 0.33 }
        }
        return ratioFloats.map { RatioValue(value: $0) }
    }
    
    private func createCellItems() -> [FLCellItem<UUID>] {
        settingsProvider.getSettingFields().compactMap { field in
            createCellItem(field: field)
        }
    }
    
    private func createCellItem(field: String) -> FLCellItem<UUID>? {
        let uid = fieldsByIds.first { entry in
            entry.value == field
        }?.key
        guard let uid else {
            assertionFailure()
            return nil
        }
        let value = dataService.getValue(field: field)
        let isReadonly = settingsProvider.isReadonly(field: field)
        let data = FLSingleValueCellData(value: value,
                                         layout: .number,
                                         readonly: isReadonly,
                                         accessKey: "cell_value_\(field)")
        let style = FLCellStyle(titleTextAttributes: .init(font: .systemFont(ofSize: 12),
                                                           color: .white),
                                valueTextAttributes: .init(font: .boldSystemFont(ofSize: 16),
                                                           color: .white),
                                backgroundColor: .backgroundViewColor,
                                validationColor: .salmon)
        return FLCellItem(uid: uid,
                          data: .titledSingleValue(data: data,
                                                   title: dataService.getTitle(field: field) ?? "",
                                                   validationText: dataService.getErrorText(field: field)),
                          style: style)
    }
    
    // MARK: -FLViewActionsDelegate
    
    func valueOfInputInCellChanged(sectionId: UUID, itemId: UUID, newValue: FLValueDataType) {
        guard let fieldName = fieldsByIds[itemId]  else {
            return
        }
        dataService.setValue(field: fieldName, value: newValue)
        updateItems()
    }
    
    func updateItems() {
        let cellItems = createCellItems()
        interaction?.update(cellItems: cellItems.map { ($0.uid, $0) })
    }
}

