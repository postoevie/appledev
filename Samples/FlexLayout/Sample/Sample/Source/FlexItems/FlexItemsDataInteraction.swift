//
//  FlexItemsDataInteraction.swift
//  Sample
//
//  Created by Igor Postoev on 20.3.24..
//

import FlexLayout

enum DataType {
    
    case integer
    case text
}

class FlexItemsDataInteraction: FlexItemsSettingsProviderProtocol, FlexItemsDataServiceProtocol {
    
    let settingParameters: [String: String?] = [
        "ratios": [33, 33, 34, 50, 50, 75, 25, 33, 33, 34, 100].map { String($0) }.joined(separator: ",")
    ]
    
    let titlesByFields: [String: String] = [
        "max_sales": "Max sales",
        "ave_sales": "Average sales",
        "sales_per_unit": "Sales per unit",
        "sales_per_store": "Sales per store",
        "best_client_comment": "Best comment",
        "delivery_response": "Delivery response",
        "deliveries_amount": "Deliveries number",
        "top_product_name": "Top product",
        "max_products_remain": "Max product number remain",
        "min_products_remain": "Min product number remain",
        "manager_comment": "Managed comment",
    ]
    
    let typesByFields: [String: DataType] = [
        "max_sales": .integer,
        "ave_sales": .integer,
        "sales_per_unit": .integer,
        "sales_per_store": .integer,
        "best_client_comment": .text,
        "delivery_response": .text,
        "deliveries_amount": .integer,
        "top_product_name": .text,
        "max_products_remain": .integer,
        "min_products_remain": .integer,
        "manager_comment": .text,
    ]
    
    var valuesbyFields: [String: Any?] = [
        "max_sales": 200,
        "ave_sales": 20,
        "sales_per_unit": 5,
        "sales_per_store": 10,
        "best_client_comment": "Comment",
        "delivery_response": "Delivered",
        "deliveries_amount": 300,
        "top_product_name": "Bike sneakers ART.5632-232-434",
        "max_products_remain": 100,
        "min_products_remain": 50,
        "manager_comment": "Deliveries and sales confirmed",
    ]
    
    var readonlyFields: [String] = []
    var requiredFields: [String] = []
    
    //MARK: FlexItemsSettingsProviderProtocol
    func getSettingFields() -> [String] {
        Array(typesByFields.keys).sorted()
    }
    
    func isRequired(field: String) -> Bool {
        requiredFields.contains(field)
    }
    
    func isReadonly(field: String) -> Bool {
        readonlyFields.contains(field)
    }
    
    func getParameter(key: String) -> String? {
        if let param = settingParameters[key] { return param }
        return nil
    }
    
    //MARK: DataServiceProtocol
    func getTitle(field: String) -> String? {
        titlesByFields[field]
    }
    
    func getValue(field: String) -> FlexLayout.FLValueDataType {
        let value = valuesbyFields[field]
        let type = typesByFields[field]
        return switch (type, value) {
        case (.text, let string as String?):
            .text(string)
        case (.integer, let number as Int?):
            if let number { .text(String(number)) } else { .text(nil) }
        default:
            { assertionFailure(); return .empty}()
        }
    }
    
    func setValue(field: String, value: FlexLayout.FLValueDataType) {
        let type = typesByFields[field]
        switch (value, type) {
        case (.text(let string), .text):
            valuesbyFields[field] = string
        case (.text(let string), .integer):
            valuesbyFields[field] = if let string { Int(string) } else { nil }
        default:
            assertionFailure("Did not set"); break
        }
    }
    
    func getErrorText(field: String) -> String? {
        guard field == "ave_sales",
              let maxSales = valuesbyFields["max_sales"] as? Int,
              let aveSales = valuesbyFields["ave_sales"] as? Int else {
            return nil
        }
        if aveSales > maxSales {
            return "Cant be more that max sales"
        }
        return nil
    }
}
