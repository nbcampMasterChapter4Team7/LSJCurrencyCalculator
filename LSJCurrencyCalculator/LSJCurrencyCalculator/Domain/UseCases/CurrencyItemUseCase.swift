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
    
    func fetchCurrencyItem(
        base: String,
        completion: @escaping (Result<[CurrencyItem], Error>) -> Void
    ) {
        do {
            try repository.fetchCurrencyItem(base: base, completion: completion)
        } catch {
            // repository.fetchCurrencyItem 에서 throw 된 에러를 completion으로 전달
            completion(.failure(error))
        }
    }
}
