import Foundation

// Boxed protocol type (existentials) allow to erase type identity preserving only protocol conformance.
// That adds flexibility because box can contain any type but adds performance cost. So its suggested to consider at first to use concrete type, then try opaques and use boxes as a last resort.
// https://docs.swift.org/swift-book/documentation/the-swift-programming-language/opaquetypes/

protocol LogServiceType {
    associatedtype LogItem
    func log(_ item: LogItem)
}

// Boxed protocol types can be used with associatedtypes as well
protocol DataInteraction: LogServiceType where LogItem == String {
    
    func load()
}

struct WebInteraction: DataInteraction {

    func load() {
        print("Starting URL session...")
    }
    
    func log(_ item: String) {
        print("Item \(item) is logged")
    }
}

struct CoreDataInteraction: DataInteraction {
    
    func load() {
        print("Fetch request is launched...")
    }
    
    func log(_ item: String) {
        print("Item \(item) is logged")
    }
}

struct FileInteraction: DataInteraction {
    
    func load() {
        print("File system is about to be accessed...")
    }
    
    func log(_ item: String) {
        print("Item \(item) is logged")
    }
}

func startupLoading(interactions: [any DataInteraction]) {
    
    for interaction in interactions {
        interaction.load()
    }
}

func log(interactions: [any DataInteraction]) {
    
    for interaction in interactions {
        interaction.log("Logged at \(Date())")
    }
}

// Constrained existentials

// Value is a generic parameter that is used as primary associated type
protocol OperationResult<Value> {
    associatedtype Value
    
    var value: Value? { get }
}

protocol ResultProducer<Value> {
    associatedtype Value
    
    func perform() -> any OperationResult<Value>
}

// Here, boxed interface Value of ResultProducer is restricted to string.
func produceString(_ producer: any ResultProducer<String>) -> String? {
    producer.perform().value
}

struct StringProducer: ResultProducer {
    
    struct Success: OperationResult {
        
        let value: String?
    }
    
    struct Failure: OperationResult {
        
        let value: String?
    }
    
    func perform() -> any OperationResult<String> {
        if Int.random(in: 1...10) % 2 == 0 {
            Success(value: "Valid result")
        } else {
            Failure(value: "Failed")
        }
    }
}

produceString(StringProducer())
