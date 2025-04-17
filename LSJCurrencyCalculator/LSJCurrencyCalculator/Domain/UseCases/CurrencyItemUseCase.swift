//
//  CurrencyItemUseCase.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/14/25.
//

import Foundation

final class CurrencyItemUseCase {
    private let repository: CurrencyItemRepositoryProtocol

    init(repository: CurrencyItemRepositoryProtocol) {
        self.repository = repository
    }

    func execute(base: String, completion: @escaping (Result<[CurrencyItem], Error>) -> Void) {
        repository.fetchCurrencyItem(base: base, completion: completion)
    }
}
