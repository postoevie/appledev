import MyMacro

let a = 17
let b = 25

let operators = #findOperators(a + b + 12 / 2 % 8)

let (result, string) = #stringify(a + b / 2)

print(string)

print("The value \(operators) was produced")
