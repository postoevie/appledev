//
//  Array+CoreData.swift
//  Pardus
//
//  Created by Igor Postoev on 28.7.24..
//

extension Array: AsyncSequence {

    public struct AsyncIterator: AsyncIteratorProtocol {
        
        let array: [Element]
        var index = 0
        public mutating func next() async -> Element? {
            guard !Task.isCancelled else {
                return nil
            }
            guard index < array.count else {
                return nil
            }
            index += 1
            return array[index - 1]
        }
    }

    public func makeAsyncIterator() -> AsyncIterator {
        return AsyncIterator(array: self)
    }
}
