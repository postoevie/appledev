func compareTuples<each T: Equatable>(lhs: (repeat each T), rhs: (repeat each T)) -> Bool {
  for (left, right) in repeat (each lhs, each rhs) {
    guard left == right else { return false }
  }
  return true
}

func memoize<each Argument: Hashable, Return>(
    _ function: @escaping (repeat each Argument) -> Return
) -> (repeat each Argument) -> Return {
    var storage = [AnyHashable: Return]()
    
    return { (argument: repeat each Argument) in
        var key = [AnyHashable]()
        repeat key.append(AnyHashable(each argument))
        
        if let result = storage[key] {
            return result
        } else {
            let result = function(repeat each argument)
            storage[key] = result
            return result
        }
    }
}

protocol DataMapper {
    associatedtype Input
    associatedtype Output
    func mapData(_ input: Input) -> Output
}

struct StringOutput {
    let stringValue: String
}

struct BoolOutput {
    let boolValue: Bool
}

struct StringDataMapper: DataMapper {
    func mapData(_ input: String) -> StringOutput {
        .init(stringValue: input)
    }
}

struct BoolDataMapper: DataMapper {
    func mapData(_ input: Bool) -> BoolOutput {
        .init(boolValue: input)
    }
}

struct Mapper<each T: DataMapper> {
    var item: (repeat each T)
    func mapValues(_ input: repeat (each T).Input) -> (repeat (each T).Output) {
        return (repeat (each item).mapData(each input))
    }
}

let boolMapper = BoolDataMapper()
let stringMapper = StringDataMapper()
let mappers = Mapper(item: (boolMapper, stringMapper))
let output = mappers.mapValues(true, "test")
