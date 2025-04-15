//
//  FetchExchangeRateUseCase.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/14/25.
//

import Foundation

final class FetchExchangeRateUseCase {
    private let repository: ExchangeRateRepositoryProtocol

    init(repository: ExchangeRateRepositoryProtocol) {
        self.repository = repository
    }

    func execute(base: String, completion: @escaping (Result<[ExchangeRate], Error>) -> Void) {
        repository.fetchExchangeRates(base: base, completion: completion)
    }
}
