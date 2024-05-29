//
//  StockService.swift
//  SmartTrade
//
//  Created by Gary She on 2024/5/27.
//

import Foundation
import Combine

struct APIService {
    
    var API_KEY: String {
        return keys.randomElement() ?? ""
    }
    
    let keys = ["DISNIARK9SAG0OW3"]
    
    func fetchSymbolsPublisher(symbol: String) -> AnyPublisher<Data, Error> {
        let keys = ["DISNIARK9SAG0OW3"]
        let API_KEY = keys.randomElement() ?? ""
        let urlString = "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=\(symbol)&apikey=\(API_KEY)"
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}