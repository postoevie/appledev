//
//  CoinsListTests.swift
//  CryptoTrackerTests
//
//  Created by Igor Postoev on 25.2.25..
//

import XCTest
@testable import CryptoTracker

final class CoinsListTests: XCTestCase {
    
    private var sut: CoinsListPresenter!
    private var viewModel: MockCoinsListViewModel!
    private var fetchUseCase: MockFetchCoinsDataUseCase!

    override func setUpWithError() throws {
        fetchUseCase = MockFetchCoinsDataUseCase()
        let presenter = CoinsListPresenter(fetchUseCase: fetchUseCase)
        fetchUseCase.responder = presenter
        
        viewModel = MockCoinsListViewModel()
        presenter.viewModel = viewModel
        
        sut = presenter
    }

    func testFillViewModelItems() throws {
        fetchUseCase.mockData = [CoinData(name: "bitcoin", price: 90_000)]
        let expectation = XCTestExpectation(description: "Make asynchronously.")
        fetchUseCase.start()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
        print(viewModel.items)
        XCTAssert(viewModel.items == [CoinsListItem(name: "bitcoin", price: "90000.0")])
    }
}

private class MockFetchCoinsDataUseCase: FetchCoinsDataUseCaseType {
    
    weak var responder: FetchCoinDataUseCaseResponder?

    var mockData: [CoinData] = []
    
    func start() {
        responder?.coinsDataFetchUseCaseCompleted(data: mockData)
    }
    
    func cancel() {

    }
}

private class MockCoinsListViewModel: CoinsListViewModelType {
    
    var items: [CoinsListItem] = []
}
