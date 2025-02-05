

protocol Account: Equatable {
    
    var startHour: Int { get }
    
    func start()
}

struct QualityDepartment: Account {
    
    var startHour: Int
    
    func start() {
        print("Start the quality dep...")
    }
}

struct DeliveryOffice: Account {
    
    var startHour: Int = 0
    
    func start() {
        print("Start the delivery office...")
    }
}

struct SecurityGroup: Account {
    
    var startHour: Int = 0
    
    func start() {
        print("Starting security support...")
    }
}

struct JoinedAccount<T, U>: Account where T: Account, U: Account {
    
    let account1: T
    let account2: U
    
    var startHour: Int {
        min(account1.startHour, account2.startHour)
    }
    
    func start() {
        account1.start()
        account2.start()
    }
}

struct DisabledAccount<T>: Account where T: Account {
    
    let account: T
    
    var startHour: Int {
        -1
    }
    
    func start() {
        if account is SecurityGroup {
            account.start()
            return
        }
        print("Account cannot be opened")
    }
}

// ---- Opaque return type -----

func identifiedJoin<T: Account, U: Account>(account1: T, account2: U) -> JoinedAccount<T, U> {
    JoinedAccount(account1: account1, account2: account2) // Underlying type is exposed to a caller and can be dependent on context
}

func join<T: Account, U: Account>(account1: T, account2: U) -> some Account {
    JoinedAccount(account1: account1, account2: account2) // Underlying type is not exposed to a caller
    // Later, JoinedAccount can be changed to another type.
    // Independent on context. Any Account implementation can be returned
}

func disable<T: Account>(account: T) -> some Account {
    // if account is SecurityGroup { return account } - invalid cuz some Account == T: Account which requires the same return type
    return DisabledAccount(account: account)
}

// Boxed version
func protoDisable<T: Account>(account: T) -> any Account {
    if let account = account as? SecurityGroup {
        return SecurityGroup()
    }
    // if account is SecurityGroup { return account } - Cannot cuz some Account == T: Account which requires the same return type
    return DisabledAccount(account: account)
}

let security = SecurityGroup(startHour: 0)
let delivery = DeliveryOffice(startHour: 8)

let disabled = disable(account: security)
let protoDisabled = protoDisable(account: security)

disable(account: security) == disable(account: security)
// join(account1: security, account2: delivery) == disabled // Compiler checks that types differ and cannot be compared
// disable(account: security) == protoDisabled Not valid due to type erasure. This sort of operator usually takes arguments of type Self

// Documentation https://docs.swift.org/swift-book/documentation/the-swift-programming-language/opaquetypes/ says its invalid
// But in fact it is
protoDisable(account: protoDisable(account: security))

protocol List {
    
    associatedtype Item
    
    var head: Item? { get }
}

extension Array: List {
    
    var head: Element? {
        last
    }
}

// Docs also say thats impossible but in fact it is
func makeList<T>(item: T) -> any List {
    [item]
}

func makeList<T>(item: T) -> some List {
    [item]
}

// ----- Opaque paramenter decl (5.7) ------
// The ability to use some with parameter declarations in places where simpler generics were being used.
protocol Billable {
    
    func calculate() -> Double
}

extension DeliveryOffice: Billable {
    
    func calculate() -> Double {
        50.0
    }
}

extension SecurityGroup: Billable {
    
    func calculate() -> Double {
        30.0
    }
}

// Calculate costs unconditionally
func calculateCosts(entities: [any Billable]) -> Double {
    entities.reduce(0) { $0 + $1.calculate() }
}

// Calculate costs for account by type (e g only for Delivery)
func _calculateCostsByDepartmentType<T: Billable>(entities: [T]) -> Double {
    entities.reduce(0) { $0 + $1.calculate() }
}

// This simplified generic syntax does mean we no longer have the ability to add more complex constraints our types,
// because there is no specific name for the synthesized generic parameter.
func calculateCostsByDepartmentType(entities: [some Billable]) -> Double {
    entities.reduce(0) { $0 + $1.calculate() }
}

// ---- Structural opaque result types -----
// Widens the range of places that opaque result types can be used.

func getExpiredBillables() -> [some Billable] {
    // [DeliveryOffice(), SecurityGroup()] Error. Same type requirement
    [DeliveryOffice(), DeliveryOffice()]
}


