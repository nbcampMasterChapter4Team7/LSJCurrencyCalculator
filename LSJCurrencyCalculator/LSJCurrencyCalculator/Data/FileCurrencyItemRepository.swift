//
//  FileCurrencyItemRepository.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/18/25.
//

import Foundation

final class FileCurrencyItemRepository: CurrencyItemRepositoryProtocol {
    private let filename: String

    /// filename은 “sample.json” 처럼 확장자 포함
    init(filename: String = "sample.json") {
        self.filename = filename
    }

    func fetchCurrencyItem(base: String,
                           completion: @escaping (Result<[CurrencyItem], Error>) -> Void) {
        DispatchQueue.global().async {
            do {
                // 1. Bundle에서 파일 URL 찾기
                guard let url = Bundle.main.url(forResource: self.filename, withExtension: nil) else {
                    throw NSError(domain: "FileNotFound",
                                  code: 0,
                                  userInfo: [NSLocalizedDescriptionKey: "\(self.filename) not found"])
                }
                // 2. 파일 데이터 로드
                let data = try Data(contentsOf: url)
                // 3. JSONDecoder로 DTO로 디코딩
                let dto = try JSONDecoder().decode(ExchangeRateDTO.self, from: data)
                // 4. DTO를 CurrencyItem 배열로 매핑
                let items = dto.rates.map {
                    CurrencyItem(currencyCode: $0.key,
                                 rate: $0.value,
                                 timeUnix: dto.timeLastUpdateUnix,
                                 change: .none,
                                 isFavorite: false)
                }
                // 5. 메인 스레드에서 콜백
                DispatchQueue.main.async {
                    completion(.success(items))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
