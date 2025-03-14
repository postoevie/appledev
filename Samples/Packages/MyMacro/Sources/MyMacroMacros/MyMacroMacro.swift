import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// Implementation of the `stringify` macro, which takes an expression
/// of any type and produces a tuple containing the value of that expression
/// and the source code that produced the value. For example
///
///     #stringify(x + y)
///
///  will expand to
///
///     (x + y, "x + y")
public struct StringifyMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) -> ExprSyntax {
        guard let argument = node.argumentList.first?.expression else {
            fatalError("compiler bug: the macro does not have any arguments")
        }
        return "(\(argument), \(literal: node.description))"
    }
}

public struct FindOperatorsMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) -> ExprSyntax {
        guard let argument = node.argumentList.first?.expression else {
            fatalError("compiler bug: the macro does not have any arguments")
        }
        let traverser = OperatorsTraverser(argument)
        traverser.traverse()
        let operatorsString = traverser.binaryOperators.joined(separator: ",")
        let result: ExprSyntax = "\(literal: operatorsString)"
        return result
    }
}

@main
struct MyMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        StringifyMacro.self,
        FindOperatorsMacro.self
    ]
}


class OperatorsTraverser: SyntaxRewriter {
    
    let expression: any SyntaxProtocol
    
    var binaryOperators = [String]()
    
    init(_ expression: some SyntaxProtocol) {
        self.expression = expression
    }
    
    func traverse() {
        _ = rewrite(expression)
    }
    
    override func visitPost(_ node: Syntax) {
        guard let infixOperator = node.as(InfixOperatorExprSyntax.self),
              let binaryOperator = infixOperator.operator.as(BinaryOperatorExprSyntax.self) else {
            return
        }
        binaryOperators.append(binaryOperator.operator.text)
    }
}
