//
//  Endpoint.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/14/25.
//

import Foundation

enum Endpoint {
    case fetchExchangeRates(base: String)

    var urlRequest: URLRequest {
        switch self {
        case .fetchExchangeRates(let base):
            let url = URL(string: "https://open.er-api.com/v6/latest/\(base)")!
            return URLRequest(url: url)
        }
    }
}
