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
    
    func fetchCachedCurrency(currencyCode: String) throws -> CachedCurrency? {
        return try repository.fetchCachedCurrency(currencyCode: currencyCode)
    }
    func compareCurrency(currencyCode: String, newCurrencyItem: CurrencyItem) throws -> RateChangeDirection {
        return try repository.compareCurrency(currencyCode: currencyCode, newCurrencyItem: newCurrencyItem)
    }
    func saveCurrency(currencyCode: String, rate: Double, timeUnix: Int) throws {
        return try repository.saveCurrency(currencyCode: currencyCode, rate: rate, timeUnix: timeUnix)
    }
    
    func isNeedCompare(timeUnix: Int) throws -> Bool {
        return try repository.isNeedCompare(timeUnix: timeUnix)
    }
}

