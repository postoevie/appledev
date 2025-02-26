//
//  CoinsNetworkService.swift
//  CryptoTracker
//
//  Created by Igor Postoev on 24.2.25..
//

import Foundation

actor FetchCoinDataNetworkService: RemoteCoinDataServiceType {
    
    func fetchCoinsList() async throws -> [String] {
        [
           "bitcoin",
           "ethereum",
       //    "doge",
       //    "ripple",
       //    "solana",
       //    "litecoin",
       ]
    }
    
    /// Fetches coin price with coin name
    func fetchCoinPrice(coinName: String) async throws -> Double {
        return try await getDummyPrice()
    }
    
    private func getNetworkPrice(coinName: String) async throws -> Double {
        var url = URL(string: "https://api.coingecko.com/api/v3/simple/price")!
        url.append(queryItems: [URLQueryItem(name: "ids", value: coinName),
                                URLQueryItem(name: "vs_currencies", value: "usd")])
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
          "accept": "application/json",
          "x-cg-pro-api-key": ""
        ]
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.httpFailed
        }
        typealias CoinPriceResult = Dictionary<String, Dictionary<String, Double>>
        guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? CoinPriceResult,
              let pricesByCurrencies = jsonObject[coinName],
              let price = pricesByCurrencies["usd"] else {
            throw NetworkError.parseFail
        }
        return price
    }
    
    private func getDummyPrice() async throws -> Double {
        try await Task.sleep(nanoseconds: 2_000_000_000)
        let remainder = Date().timeIntervalSince1970.truncatingRemainder(dividingBy: 1000)
        return (remainder * 100000).truncatingRemainder(dividingBy: 1000)
    }
}

