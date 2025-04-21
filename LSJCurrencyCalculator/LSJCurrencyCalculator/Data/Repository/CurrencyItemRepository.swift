//
//  CurrencyItemRepository.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/14/25.
//

import Foundation

final class CurrencyItemRepository: CurrencyItemRepositoryProtocol {

    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func fetchCurrencyItem(base: String, completion: @escaping (Result<[CurrencyItem], Error>) -> Void) {
        apiClient.request(Endpoint.fetchExchangeRates(base: base)) { (result: Result<ExchangeRateDTO, Error>) in
            switch result {
            case .success(let dto):
                let entities = dto.rates.map { CurrencyItem(currencyCode: $0.key, rate: $0.value, timeUnix: dto.timeLastUpdateUnix, change: .none, isFavorite: false) }
                completion(.success(entities))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
