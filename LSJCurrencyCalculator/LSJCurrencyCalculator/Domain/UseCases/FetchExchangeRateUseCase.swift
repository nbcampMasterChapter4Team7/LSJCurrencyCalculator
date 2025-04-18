//
//  FetchExchangeRateUseCase.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/18/25.
//

import Foundation

/// Domain UseCase: 환율 데이터를 가져오고, 캐시와 비교하여 업데이트 및 저장까지 처리
final class FetchExchangeRatesUseCase {
    private let repository: CurrencyItemRepositoryProtocol
    private let cachedUseCase: CachedCurrencyUseCase

    init(
        repository: CurrencyItemRepositoryProtocol,
        cachedUseCase: CachedCurrencyUseCase
    ) {
        self.repository = repository
        self.cachedUseCase = cachedUseCase
    }

    /// API에서 환율을 가져오고, cache와 비교·저장한 뒤 Domain 엔티티 배열을 반환
    func execute(
        base: String,
        completion: @escaping (Result<[CurrencyItem], Error>) -> Void
    ) {
        repository.fetchCurrencyItem(base: base) { result in
            switch result {
            case .success(let apiItems):
                // API 호출 성공 시 비즈니스 로직 처리
                do {
                    let processed = try self.process(apiItems: apiItems)
                    completion(.success(processed))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    /// API로부터 받은 items를 캐시와 비교·갱신 후 최종 CurrencyItem 리스트로 반환
    private func process(apiItems: [CurrencyItem]) throws -> [CurrencyItem] {
        guard let first = apiItems.first else { return [] }
        let currentTime = first.timeUnix

        // 시간 비교
        if try cachedUseCase.isNeedCompare(timeUnix: currentTime) {
            // 시간 다르면 하나씩 비교 후 캐시 저장
            var result: [CurrencyItem] = []
            for item in apiItems {
                let direction = try cachedUseCase.compareCurrency(
                    currencyCode: item.currencyCode,
                    newCurrencyItem: item
                )
                // 캐시에 저장
                try cachedUseCase.saveCurrency(currencyCode: item.currencyCode,
                                               rate: item.rate,
                                               timeUnix: currentTime, change: direction.rawValue
                )
                // Domain 엔티티 생성
                result.append(
                    CurrencyItem(
                        currencyCode: item.currencyCode,
                        rate: item.rate,
                        timeUnix: currentTime,
                        change: direction,
                        isFavorite: false
                    )
                )
            }
            return result
        } else {
            // 시간 같으면 캐시된 모든 환율을 로드
            let cached = try cachedUseCase.fetchAllCachedCurrency()
            return cached.map { c in
                CurrencyItem(
                    currencyCode: c.currencyCode,
                    rate: c.rate,
                    timeUnix: currentTime,
                    change: RateChangeDirection(rawValue: c.change) ?? .none,
                    isFavorite: false
                )
            }
        }
    }
}
