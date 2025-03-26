//
//  CryptoTrackerTests.swift
//  CryptoTrackerTests
//
//  Created by Igor Postoev on 18.2.25..
//

import XCTest

class ThreadUnsafeType {
    
    var isRunning = false
    
    func start() {
        if isRunning {
           return
        }
        isRunning = true
        print("Start the job!")
    }
}

class ThreadSafeType {
    
    let queue = DispatchQueue(label: "cryptotest.queue")
    
    var isRunning = false
    var isRunning0 = false
    var isRunning1 = false
    var isRunning2 = false
    var isRunning3 = false
    var isRunning4 = false
    var isRunning5 = false
    
    
    func start() {
        queue.async {
            if self.isRunning,
               self.isRunning0,
                self.isRunning1,
                self.isRunning2,
                self.isRunning3,
                self.isRunning4,
                self.isRunning5 {
               return
            }
            self.isRunning = true
            self.isRunning0 = true
            self.isRunning1 = true
            self.isRunning2 = true
            self.isRunning3 = true
            self.isRunning4 = true
            self.isRunning5 = true
            print("Start the job!")
        }
    }
}

final class CryptoTrackerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    let concurrentQueue = DispatchQueue(label: "cryptotest.concurrent", attributes: .concurrent)
    
    func testExampleUnsafe() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        
        let threadUnsafe = ThreadUnsafeType()
        let expectation = XCTestExpectation()
        for _ in 0..<50 {
            concurrentQueue.async {
                Thread.sleep(forTimeInterval: 0.3)
                threadUnsafe.start()
            }
        }
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
    }
    
    
    func testExampleSafe() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        
        let threadUnsafe = ThreadSafeType()
        let expectation = XCTestExpectation()
        for _ in 0..<50 {
            concurrentQueue.async {
                Thread.sleep(forTimeInterval: 0.1)
                threadUnsafe.start()
            }
        }
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 30)
    }

}
