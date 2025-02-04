До Swift 5.9 универсальные(generic) функции требовали фиксированное количество параметров типа.
Нельзя было написать универсальную функцию, принимающую произвольное количество аргументов с различными типами.

Например, есть функция, которая сравнивает кортежи заданного размера. В стандартной библиотеке количество элементов ограничено 6.
func == (lhs: (), rhs: ()) -> Bool
func == <A, B>(lhs: (A, B), rhs: (A, B)) -> Bool where A: Equatable, B: Equatable...Видно, что приходится делать перегрузки для определенного количества аргументов, что затрудняет поддержку и накладывает ограничения на масштабируемость.

Если попытаться использовать вариативный аргумент
func == (lhs: Equatable..., rhs: Equatable...) -> Boolто появится другое ограничение - исчезнет информация о типах аргументов (произойдет type erasure) и сравнить пары значений не удастся.

Чтобы учесть ограничения, в Swift 5.9 представили пакеты параметров типов (type parameter pack) и пакеты параметров значений (value parameter pack). Параметры типа - то что пишется в <> после имени функции. Пакеты могут включать произвольное число параметров, начиная с 0; для их объявления используется ключевое слово each;
Для развертывания(расширения) пакета, перед ним применяется ключевое слово repeat (шаблон повторения). Применение его означает что шаблон(выражение после repeat) используется для каждого элемента развернутого пакета.

С новыми возможностями, приведенная выше сигратура будет иметь вид
func == <each Element: Equatable>(lhs: (repeat each Element), rhs: (repeat each Element)) -> Bool...А начиная с Swift 6.0 добавили возможность итерации по расширению пакета значений и тело функции может выглядеть так
func == <each Element: Equatable>(lhs: (repeat each Element), rhs: (repeat each Element)) -> Bool {
  for (left, right) in repeat (each lhs, each rhs) {
    guard left == right else { return false }
  }
  return true
}...Конечно тема более глубокая. Есть ряд правил применения, ограничений, и в то же время новых возможностей.

https://github.com/swiftlang/swift-evolution/blob/main/proposals/0393-parameter-packs.md#type-matching
https://medium.com/@andykolean_89531/value-and-type-parameter-packs-in-swift-530e2d95f140
https://paul-samuels.com/blog/2023/09/29/swift-parameter-packs/
https://www.avanderlee.com/swift/value-and-type-parameter-packs/
https://www.hackingwithswift.com/articles/269/whats-new-in-swift-6


Пример применения функции с произвольным количеством аргументов и их типов:

struct Pair<First, Second> {
  init(_ first: First, _ second: Second)
}

// each First, each Second - пакеты параметров типа
// first: repeat each First, second: repeat each Second - пакеты параметров значений
func makePairs<each First, each Second>(
  firsts first: repeat each First,
  seconds second: repeat each Second
) -> (repeat Pair<each First, each Second>) {
  // повторяет(repeat) шаблон создания структуры Pair для каждой (each) пары из пакетов значений значений first и second. видно, что результат применения each first и each second - инстансы First и Second соотв.
  return (repeat Pair(each first, each second))
}

let pairs = makePairs(firsts: 1, "hello", seconds: true, 1.0)
// '(Pair(1, true), Pair("hello", 2.0))'
// на основании типов переданных значений вывод, что 
// each First развертывается в { Int, Bool }
// each Second развертывается в { String, Double }
// first: repeat each First развертывается в { 1, true }
// second: repeat each Second развертывается в { "hello", 2.0 }


Развертывание пакета

При развертывании вложенные пакеты не учитывается(не развертываются).
т е  если в предыдущем примере передать в качестве одного из значений пакет значений то он не развернется.

Пакет типа имеет те же ограничения что и обычные типы при его развертывании, как в примере с 
repeat Set<each T>. each T: Hashable - соответствует ограничению сета, each T - нет.


Замена типа

- Расширение захваченного пакета параметров типа есть его замена на некоторый замещающий список типов (например, список типов передаваемых в функцию аргументов).

- Все заменяяющие спискт типов должны иметь одинаковую длину.

- Допускается, если каждый i-тый эламент замещающего списка - скалярный тип (без repeat).

- Допускается, если каждый i-тый эламент замещающего списка - тип расширения пакета (repeat).

- Другие комбинации запрещены.

На примере объяснили что такое захват пакета параметров типа.

Есть объявление функции:
func variadic<each T, each U>(t: repeat each T, u: repeat each U) -> (repeat (each T) -> (repeat each U))

Например, типы замены таковы:
T := {Int, String}
U := {Float, Double, Character}

Тогда итоговый возвращаемый тип будет:
((Int) -> (Float, Double, Character), (String) -> (Float, Double, Character)) 

Видно, что первой операцией repeat захвачен пакет параметров T и первое расширение произойдет для него. Для каждого вхождения расширенного пакета Т, вторая repeat расширяет пакет параметров U.

Возможно выыполнить repeat с конкретным типом, без захвата пакетов параметров типа
func counts<each T: Collection>(_ t: repeat each T) {
  let x = (repeat (each t).count)
}
Здесь х приобретет тип (repeat Int)

В случае, если заменяющий набор пакета параметров типа each T сожержит кортеж с единственным элементом T, то результатом расширения будет просто тип T.
each T := {Int} into (repeat each T) => Int

Сопоставление типов

Типы замещений в универстальной функции исходят из типов аргументов при вызове и контекстное значение при возврате функции (не пишутся явно в исходниках)

Если вызываемое -функция с именами параметров то сопоставление по меткам. Иначе. по списку типов.

Сопоставление по меткам
Если в объявлении метода есть тип раcширения пакета, то он должен либо быть последним в списке, либо находиться до параметра с меткой.

Сопоставление по закрывающему замыканию (trailing closure).

Сопоставление по списку типов возможно если тип расширения пакета будет соседствовать с конкретным типом / типами.

(Int, repeat each T, String) (Int, Double, Float, String) - первый и последний типы сопоставлены, оставляя repeat each T := { Dobule, Float }

(x: Int, repeat each T, z: String) (x: Int, Double, y: Float, z: String) ошибочен, так как после сопоставления конкретных типов остается аргумент с меткой, что недопустимо.

(x: Int, repeat each T, z: String) (x: Int, Double, Float, z: String) repeat each T := Double, Float



