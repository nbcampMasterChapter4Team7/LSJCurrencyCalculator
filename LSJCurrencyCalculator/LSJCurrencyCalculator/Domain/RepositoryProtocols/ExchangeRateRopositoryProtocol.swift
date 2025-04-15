//
//  ExchangeRateRopositoryProtocol.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/14/25.
//

import Foundation

protocol ExchangeRateRepositoryProtocol {
    func fetchExchangeRates(base: String, completion: @escaping (Result<[ExchangeRate], Error>) -> Void)
}
