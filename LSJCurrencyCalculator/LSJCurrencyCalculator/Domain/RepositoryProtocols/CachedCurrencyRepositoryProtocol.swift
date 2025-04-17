//
//  CachedCurrencyRepositoryProtocol.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/17/25.
//

import Foundation

protocol CachedCurrencyRepositoryProtocol {
    func fetchCachedCurrency(currency: String, date: Date) throws -> [CachedCurrency]
    func compareCurrency(currency: String) throws -> RateChangeDirection
    func cachingCurrency(currency: String, rate: Double, date: Date) throws
}
