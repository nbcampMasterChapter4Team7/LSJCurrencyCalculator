//
//  CachedCurrencyRepositoryProtocol.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/17/25.
//

import Foundation

protocol CachedCurrencyRepositoryProtocol {
    func fetchCachedCurrency(currencyCode: String, date: Date) throws -> CachedCurrency?
    func compareCurrency(currencyCode: String, newCurrencyItem: CurrencyItem) throws -> RateChangeDirection
    func cachingCurrency(currencyCode: String, rate: Double, date: Date) throws
}
