//
//  CurrencyItemRepositoryTests.swift
//  LSJCurrencyCalculatorTests
//
//  Created by yimkeul on 4/22/25.
//

import XCTest
import CoreData
@testable import LSJCurrencyCalculator

/// APIClientProtocol을 목(Mock)으로 구현
final class MockAPIClient: APIClientProtocol {
    var resultToReturn: Result<ExchangeRateDTO, Error>!
    
    func request<T>(
        _ endpoint: Endpoint,
        completion: @escaping (Result<T, Error>) -> Void
    ) where T : Decodable {
        // Given: 사전에 설정해 둔 resultToReturn을 그대로 내려줌
        switch resultToReturn! {
        case .success(let dto):
            completion(.success(dto as! T))
        case .failure(let e):
            completion(.failure(e))
        }
    }
}

final class CurrencyItemRepositoryTests: XCTestCase {
    var mockClient: MockAPIClient!
    var repository: CurrencyItemRepository!

    override func setUp() {
        super.setUp()
        mockClient = MockAPIClient()
        repository = CurrencyItemRepository(apiClient: mockClient)
    }

    override func tearDown() {
        repository = nil
        mockClient = nil
        super.tearDown()
    }

    func testFetchCurrencyItem_success() throws {
        // Given: 정상 DTO를 반환하도록 설정
        let sampleRates = ["USD": 1.0, "EUR": 0.5]
        let dto = ExchangeRateDTO(
            result: "success",
            provider: "", documentation: "", termsOfUse: "",
            timeLastUpdateUnix: 123,
            timeLastUpdateUTC: "", timeNextUpdateUnix: 0, timeNextUpdateUTC: "",
            timeEOLUnix: 0, baseCode: "USD",
            rates: sampleRates
        )
        mockClient.resultToReturn = .success(dto)
        let exp = expectation(description: "fetchSuccess")

        // When
        repository.fetchCurrencyItem(base: "USD") { result in
            // Then
            switch result {
            case .success(let items):
                XCTAssertEqual(items.count, sampleRates.count)
            case .failure(let error):
                XCTFail("예상치 못한 실패: \(error)")
            }
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1)
    }

    func testFetchCurrencyItem_failure() throws {
        // Given: 네트워크 에러를 반환하도록 설정
        let testError = NSError(domain: "Test", code: 42)
        mockClient.resultToReturn = .failure(testError)
        let exp = expectation(description: "fetchFailure")

        // When
        repository.fetchCurrencyItem(base: "USD") { result in
            // Then
            switch result {
            case .success:
                XCTFail("실패 케이스에서 성공 결과가 나왔습니다")
            case .failure(let error as NSError):
                XCTAssertEqual(error, testError)
            default:
                break
            }
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1)
    }
}
