//
//  FetchCoinsDataUseCase.swift
//  CryptoTrackerTests
//
//  Created by Igor Postoev on 25.2.25..
//

import XCTest
@testable import CryptoTracker

final class FetchCoinsDataUseCaseTests: XCTestCase {

    private var sut: FetchCoinsDataUseCase!
    private var fetchService: MockFetchCoinDataService!
    
    override func setUpWithError() throws {
        fetchService = MockFetchCoinDataService()
        sut = FetchCoinsDataUseCase(fireInterval: 3.0,
                                    fetchService: fetchService)
    }

    func testFillViewModelItems() throws {
        let uiResponder = MockUIResponder()
        let saveResponder = MockSaveResponder()
        
        sut.subscribe(uiResponder)
        sut.subscribe(saveResponder)
        
        let beforeTickExpectation = XCTestExpectation()
        
        fetchService.coinsList = ["bitcoin"]
        fetchService.mockData = ["bitcoin": 90_000]
        
        sut.start()
        
        // Test before timer fires
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssert(uiResponder.savedData == [CoinData(name: "bitcoin", price: 90_000)])
            XCTAssert(saveResponder.savedData == [CoinData(name: "bitcoin", price: 90_000)])
            beforeTickExpectation.fulfill()
        }
        wait(for: [beforeTickExpectation], timeout: 10)
        
        self.fetchService.mockData = ["bitcoin": 100_000] // Imitate data changing
        
        let afterTickExpectation = XCTestExpectation()
        
        // Wait for timer to tick (3 sec)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            XCTAssert(uiResponder.savedData == [CoinData(name: "bitcoin", price: 100_000)])
            XCTAssert(saveResponder.savedData == [CoinData(name: "bitcoin", price: 100_000)])
            afterTickExpectation.fulfill()
        }
        
        wait(for: [afterTickExpectation], timeout: 10)
    }
}

private class MockFetchCoinDataService: FetchCoinDataServiceType {
    
    var mockData: [String: Double] = [:]
    var coinsList: [String] = []
    
    func fetchCoinsList() async throws -> [String] {
        coinsList
    }
    
    func fetchCoinPrice(coinName: String) async throws -> Double {
        mockData[coinName]!
    }
}

private class MockSaveResponder: SaveCoinDataServiceType {
    
    var savedData: [CoinData] = []
    var expectation: XCTestExpectation?
    
    func coinsDataFetchUseCaseCompleted(data: [CoinData]) {
        savedData = data
        expectation?.fulfill()
    }
}

private class MockUIResponder: FetchCoinDataUseCaseResponder {
    
    var savedData: [CoinData] = []
    var expectation: XCTestExpectation?
    
    func coinsDataFetchUseCaseCompleted(data: [CoinData]) {
        savedData = data
        expectation?.fulfill()
    }
}


