Макросы позволяют заменить некоторую логику именем, которое “развертывается” в нее во время компиляции. Это позволяет избавиться от повторений кода.
В Swift имеются обособленные макросы (freestanding macros) и прикладываемые макросы(attachment macros).

Первые вызываются так же как функции в виде #<имя макроса>(параметры).
Пример использования #fontLiteral:
let _: Font = #fontLiteral(name: "SF Mono", size: 14, weight: .regular)Еще макросы - #Predicate, #file, swift-power-assert, swift-macro-testing

Прикладываемые макросы указываются при объявлении типа, как в примере c @OptionSet:

@OptionSet<Int>
struct SundaeToppings {
    private enum Options: Int {
        case nuts
        case cherry
        case fudge
    }
}

Еще макросы - @Observable, swift-spyable, MetaCodable

При создании собственного макроса, сперва его нужно объявить, указав где лежит его реализация.
Объявление может включать атрибуты указывающие на тип, роли макроса и т д (перечислены здесь Attributes.).
Пример объявления freestanding expression макроса:
@freestanding(expression)
public macro stringify<T>(_ value: T) -> (T, String) = #externalMacro(module: "MyMacroMacros",  type: "StringifyMacro")...Как работает:
Сперва компилятор считывает код вызова макроса в виде дерева синтаксиса. Простой пример такого дерева для естественного языка - роли слов в предложении (сказумое, подлежащее …). В коде на Swift подобное дерево реализуется библиотекой SwiftSyntax.
Затем передает это дерево в имплементацию макроса. 
Макрос возвращает другое дерево согласно его имплементации - “развертывая” переданное (expansion).
Результат развертывание подменяет вызов макроса.

Коллекция макросов от сообщества - https://github.com/krzysztofzablocki/Swift-Macros

https://docs.swift.org/swift-book/documentation/the-swift-programming-language/macros/
https://developer.apple.com/documentation/swift/optionset
https://www.swift.org/blog/swift-5.9-released