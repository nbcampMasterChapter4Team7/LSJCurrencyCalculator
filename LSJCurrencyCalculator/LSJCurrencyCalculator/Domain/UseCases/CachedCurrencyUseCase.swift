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

    func fetchAllCachedCurrency() throws -> [CachedCurrency] {
        return try repository.fetchAllCachedCurrency()
    }

    func fetchCachedCurrency(currencyCode: String) throws -> CachedCurrency? {
        return try repository.fetchCachedCurrency(currencyCode: currencyCode)
    }
    func compareCurrency(currencyCode: String, newCurrencyItem: CurrencyItem) throws -> RateChangeDirection {
        return try repository.compareCurrency(currencyCode: currencyCode, newCurrencyItem: newCurrencyItem)
    }
    func saveCurrency(currencyCode: String, rate: Double, timeUnix: Int, change: String) throws {
        return try repository.saveCurrency(currencyCode: currencyCode, rate: rate, timeUnix: timeUnix, change: change)
    }

    func isNeedCompare(timeUnix: Int) throws -> Bool {
        return try repository.isNeedCompare(timeUnix: timeUnix)
    }
    
    func compareAndUpdateRates(currencyItems: [CurrencyItem]) throws -> [CurrencyItem] {
        return try repository.compareAndUpdateRates(currencyItems: currencyItems)
    }
}

