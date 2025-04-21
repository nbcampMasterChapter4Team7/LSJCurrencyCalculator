//
//  APIClientProtocol.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/21/25.
//

import Foundation

protocol APIClientProtocol {
    func request<T: Decodable>(
        _ endpoint: Endpoint,
        completion: @escaping (Result<T, Error>) -> Void
    )
}
