//
//  CachedCurrencyUseCase.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/17/25.
//

import Foundation

final class CachedCurrencyUseCase {
    private let repository: CachedCurrencyRepositoryProtocol
    
    init(repository: CachedCurrencyRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchCachedCurrency(currencyCode: String, date: Date) throws -> CachedCurrency? {
        return try repository.fetchCachedCurrency(currencyCode: currencyCode, date: date)
    }
    func compareCurrency(currencyCode: String, newCurrencyItem: CurrencyItem) throws -> RateChangeDirection {
        return try repository.compareCurrency(currencyCode: currencyCode, newCurrencyItem: newCurrencyItem)
    }
    func cachingCurrency(currencyCode: String, rate: Double, date: Date) throws {
        return try repository.cachingCurrency(currencyCode: currencyCode, rate: rate, date: date)
    }
}
