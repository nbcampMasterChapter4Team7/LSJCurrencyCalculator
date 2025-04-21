//
//  CachedCurrencyRepositoryProtocol.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/17/25.
//

import Foundation

protocol CachedCurrencyRepositoryProtocol {
    func fetchAllCachedCurrency() throws -> [CachedCurrency]
    func fetchCachedCurrency(currencyCode: String) throws -> CachedCurrency?
    func compareCurrency(currencyCode: String, newCurrencyItem: CurrencyItem) throws -> RateChangeDirection
    func saveCurrency(currencyCode: String, rate: Double, timeUnix: Int, change: String) throws
    func isNeedCompare(timeUnix: Int) throws -> Bool
    func compareAndUpdateRates(currencyItems: [CurrencyItem]) throws -> [CurrencyItem]
}
