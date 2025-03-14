
Memory safety

Есть сценарии которые могут стать причиной конфликтов. Они могут возникнуть если в один момент времени происходят два доступа к одному участку памяти, и хотя бы один из них - на запись и оба не-атомарные. Доступ может быть мгновенным (instantaneous) или продолжительным (long-term) - при втором возможно выполнение инструкций и пересечения(overlap) с другими доступами.

Оператор ionut позволяет получить доступ на запись передаваемого в функцию параметра.
При этом, у функции, на время выполнения ее тела, имеется продолжительный доступ на запись - и это может быть причиной возникновения пересечения с другим доступом, нарушению эксклюзивности и конфликтам.

В примере доступ на запись пересекается с доступом на чтения (происходят одновременно), что ведет к ошибке. Также возможны два одновременных доступа на запись.

var stepSize = 1
func increment(_ number: inout Int) {
    number += stepSize
}
increment(&stepSize)

Также конфликты могут возникнуть при именении структур, кортежей, енамов. При изменении элемента структуры меняется и вся структура, что значит, что при наличии доступа к одному ее свойству имеется и доступ ко всей структуре.

func balance(_ x: inout Int, _ y: inout Int) {
    let sum = x + y
    x = sum / 2
    y = sum - x
}

// Здесь ошибка возникнет из-за доступа на запись памяти, создержащей holly.
// Simultaneous accesses to 0x13cf12a38, but modification requires exclusive access
var holly = Player(name: "Holly", health: 10, energy: 10)
balance(&holly.health, &holly.energy)

func someFunction() {
	// Здесь компилятор сочтет операцию безопасной, так как переменная локальна и не захвачена escaping замыканием
    var oscar = Player(name: "Oscar", health: 10, energy: 10)
    balance(&oscar.health, &oscar.energy)  // OK
}

https://docs.swift.org/swift-book/documentation/the-swift-programming-language/memorysafety/



Ownership

Владение памятью в Swift описывается манифестом 
https://github.com/swiftlang/swift/commit/4c67c1d45b6f9649cc39bbb296d63663c1ef841f

Владение - ответственость некоторой части кода очистить память переменной. Обрести его можно создав копию (для значений), либо увеличив счетчик ARC.

Обычно среда управляет памятью самостоятельно, избегая некорректного использования ресурсов - например, доступа к освобожденной памяти. Это обеспечивается "законом эксклюзивности".
https://github.com/apple/swift-evolution/blob/main/proposals/0176-enforce-exclusive-access-to-memory.md

Чтобы добиться безопасного управления памятью, среда требует, чтобы доступ к переменной был эксклюзивен при ее изменении.

Начиная с 5.9 работает обязательная эксклюзивность. Это нужно:

-  для обеспечения производительности и безопасности памяти. Производительность достигается тем, что для каждого параметра - свой регистр и доступ по ссылкам уменьшен. Компилятор не допускает что inout параметр - одна и та же переменная. 

- предоставлить возможность разработчику возможность менять стандартное поведение компилятора (по умолчанию).

По умолчанию, при передаче переменной в конструктор, он "обретает" владение переменной. При передаче же в функцию - этого не происходит.

В 5 9 появилась возможность изменить это дефолтное поведение для достижения лучшего перформанса (например, за счет ограничения лишних копирований).

borrowing - вызывающий остается владельцем переменной, не нужно делать копию, ответственен за то чтобы переменная не очистилась пока вызываемый выполняется. вызываемый же не ответственен за очистку и не может неявно копировать параметр(доступ на чтение).

consuming - вызывающий отдает владение переменной вызываемому. либо копирует переменную, чтобы сохранить владение ею. вызываемый должен очистить память переменной либо передать владение далее.

Так, чтобы добиться перформанса можно, например указывать borrowing в параметре конструктора либо consuming у параметра функции (например, сеттера).

Иногда компилятор может и сам делать подобные оптимизации. 
https://github.com/apple/swift/blob/main/docs/OptimizationTips.rst

Материал выше взят с https://infinum.com/blog/swift-ownership/ Там же представлен код на ассемблере и бенчмарк.

Оператор Consume 

Подсчет ссылок и Copy-On-Write, при работе с переменными семантики значений (values), автоматически определяют как выделятся и высвобждается память. В новых версиях языка появилась возможность вручную изменять это поведение для достижения лучшего перформанса.

Ввели оператор consume, который завершает время существования (lifetime) переменной (т. е. "отвязывает" имя от выделенной памяти) и позволяет передать владение ею (forward ownership) другой переменной или аргументу функции.
Например,

```
func useUniquely(_ value: consuming [Int]) {
	var y = consume value // Передача владения из value в y

	y.append(4) // Без consume произошло бы излишнее копирование из value (согласно COW)
}

let x = [1, 2, 3]
useUniquely(consume x) // "Отвязать" переменную x от [1, 2, 3] и передать во владение аргументу value в useUniquely.

// Здесь при попытке po x выведется "error: cannot find 'x' in scope"

let y = x // Ошибка компилятора "x used after consume".
```

https://github.com/swiftlang/swift-evolution/blob/main/proposals/0366-move-function.md

Также ввели некопируемые структуры и перечисления (~Copyable) о которых напишу далее.
