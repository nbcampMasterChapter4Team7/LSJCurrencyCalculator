//
//  ExchangeRateRepository.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/14/25.
//

import Foundation

final class ExchangeRateRepository: ExchangeRateRepositoryProtocol {

    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func fetchExchangeRates(base: String, completion: @escaping (Result<[ExchangeRate], Error>) -> Void) {
        apiClient.request(Endpoint.fetchExchangeRates(base: base)) { (result: Result<ExchangeRateDTO, Error>) in
            switch result {
            case .success(let dto):
                let entities = dto.rates.map { ExchangeRate(currency: $0.key, rate: $0.value) }
                completion(.success(entities))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
