import XCTest
@testable import SwiftFeatures

func update(array: [Int]) -> [Int] {
    var arrayCopy = array
    arrayCopy.append(array.count % 10)
    return arrayCopy
}

func updateConsuming(array: consuming [Int]) {
    //array.append(array.count % 10)
}


final class MemoryManagement: XCTestCase {
    
    func testExample() throws {
        var variable = 1
        variable += variable
        print(variable)
        measure(metrics: [XCTMemoryMetric(), XCTCPUMetric()]) {
            var array = [Int]()
            for index in 0..<10000 {
                array = update(array: array)
            }
        }
    }
    
    func testExampleConsuming() throws {

        measure(metrics: [XCTMemoryMetric(), XCTCPUMetric()]) {
            var array = [Int]()
            for index in 0..<10000 {
                updateConsuming(array: array)
            }
        }
    }
    
    func testNonCopyable() {
        
        struct Player: ~Copyable {
            
            private(set) var hitPoint = 100
            let damage = 50
            
            mutating func takeHit(_ damage: Int) {
                hitPoint -= damage
            }
            
            consuming func kill() {
                print("Game over")
            }
        }
        
        func checkHP(player: borrowing Player) {
            print("Player's HP is \(player.hitPoint)")
        }
        
        func endGame(player: consuming Player) {
            player.kill()
        }
        
        var player1 = Player()
        //var player2 = player1 cannot be used after consume
        
        var player3 = Player()
        player1.takeHit(player3.damage)
        player3.kill()
        // player3.takeHit(player1.damage) player3 cannot be used after consume
        
        checkHP(player: player1)
        endGame(player: player1)
    }
}
