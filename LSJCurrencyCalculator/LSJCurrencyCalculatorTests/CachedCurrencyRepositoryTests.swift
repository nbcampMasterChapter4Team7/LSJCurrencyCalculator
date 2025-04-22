//
//  CachedCurrencyRepositoryTests.swift
//  LSJCurrencyCalculatorTests
//
//  Created by yimkeul on 4/22/25.
//

import XCTest
import CoreData
@testable import LSJCurrencyCalculator

final class CachedCurrencyRepositoryTests: XCTestCase {
    var container: NSPersistentContainer!
    var repository: CachedCurrencyRepository!

    override func setUp() {
        super.setUp()
        // Given: In‐Memory CoreData 컨테이너 준비
        container = NSPersistentContainer(name: "CurrencyCoreData")
        let desc = NSPersistentStoreDescription()
        desc.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [desc]
        container.loadPersistentStores { _, error in
            XCTAssertNil(error)
        }
        repository = CachedCurrencyRepository(persistentContainer: container)
    }

    override func tearDown() {
        repository = nil
        container = nil
        super.tearDown()
    }

    func testFetchAllCachedCurrency_empty() throws {
        // Given: 아무 것도 저장되지 않은 상태
        // When
        let all = try repository.fetchAllCachedCurrency()
        // Then
        XCTAssertTrue(all.isEmpty)
    }

    func testIsNeedCompare_whenEmpty_returnsTrue() throws {
        // Given: 저장된 항목이 없을 때
        // When
        let need = try repository.isNeedCompare(timeUnix: 1000)
        // Then
        XCTAssertTrue(need)
    }

    func testSaveCurrency_andFetchCachedCurrency() throws {
        let code = "USD"
        let rate: Double = 1.23
        let time = 42

        // When: saveCurrency 호출
        try repository.saveCurrency(currencyCode: code, rate: rate, timeUnix: time, change: "none")

        // Then: fetchCachedCurrency 로 가져올 수 있어야 함
        let fetched = try repository.fetchCachedCurrency(currencyCode: code)
        XCTAssertNotNil(fetched)
        XCTAssertEqual(fetched?.currencyCode, code)
        XCTAssertEqual(fetched?.rate, rate)
        XCTAssertEqual(fetched?.timeUnix, Int64(time))
        XCTAssertEqual(fetched?.change, "none")
    }

    func testCompareCurrency_up_down_none() throws {
        let code = "EUR"
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        // Given: 과거 캐시에 1.0 저장
        try repository.saveCurrency(currencyCode: code, rate: 1.0, timeUnix: Int(yesterday.timeIntervalSince1970), change: "none")

        let baseTime = Int(yesterday.timeIntervalSince1970)
        let newerUp = CurrencyItem(currencyCode: code, rate: 1.5, timeUnix: baseTime, change: .none, isFavorite: false)
        let newerDown = CurrencyItem(currencyCode: code, rate: 0.5, timeUnix: baseTime, change: .none, isFavorite: false)
        let newerSame = CurrencyItem(currencyCode: code, rate: 1.005, timeUnix: baseTime, change: .none, isFavorite: false)

        // When & Then
        XCTAssertEqual(try repository.compareCurrency(currencyCode: code, newCurrencyItem: newerUp), .up)
        XCTAssertEqual(try repository.compareCurrency(currencyCode: code, newCurrencyItem: newerDown), .down)
        XCTAssertEqual(try repository.compareCurrency(currencyCode: code, newCurrencyItem: newerSame), .none)
    }

    func testIsNeedCompare_whenTimeMatches_returnsFalse() throws {
        let code = "JPY"
        let now = Int(Date().timeIntervalSince1970)
        // Given: 같은 timeUnix로 저장
        try repository.saveCurrency(currencyCode: code, rate: 100, timeUnix: now, change: "none")
        // When
        let need = try repository.isNeedCompare(timeUnix: now)
        // Then
        XCTAssertFalse(need)
    }

    func testCompareAndUpdateRates_timeDifferent_createsNewAndReturnsUpdatedItems() throws {
        let now = Int(Date().timeIntervalSince1970)
        let items = [
            CurrencyItem(currencyCode: "A", rate: 2.0, timeUnix: now, change: .none, isFavorite: false),
            CurrencyItem(currencyCode: "B", rate: 3.0, timeUnix: now, change: .none, isFavorite: false)
        ]

        // Given: 캐시가 비어 있어야 비교 필요(true)
        XCTAssertTrue(try repository.isNeedCompare(timeUnix: now))

        // When
        let updated = try repository.compareAndUpdateRates(currencyItems: items)

        // Then: 캐시에도 저장되고, 반환된 items도 동일한 count & rate
        let allCached = try repository.fetchAllCachedCurrency()
        XCTAssertEqual(allCached.count, 2)
        XCTAssertEqual(updated.map(\.currencyCode), ["A", "B"])
        XCTAssertEqual(updated.map(\.rate), [2.0, 3.0])
    }

    func testCompareAndUpdateRates_timeSame_loadsFromCache() throws {
        let now = Int(Date().timeIntervalSince1970)
        // Given: 먼저 캐시에 저장
        try repository.saveCurrency(currencyCode: "X", rate: 9.9, timeUnix: now, change: "up")
        try repository.saveCurrency(currencyCode: "Y", rate: 8.8, timeUnix: now, change: "down")

        // When: same timeUnix로 호출
        let items: [CurrencyItem] = try repository.compareAndUpdateRates(currencyItems: [
            CurrencyItem(currencyCode: "X", rate: 0, timeUnix: now, change: .none, isFavorite: false),
            CurrencyItem(currencyCode: "Y", rate: 0, timeUnix: now, change: .none, isFavorite: false)
        ])

        // Then: 캐시에 저장된 값이 반환되어야 함
        XCTAssertEqual(items.count, 2)
        XCTAssertTrue(items.contains { $0.currencyCode == "X" && $0.rate == 9.9 })
        XCTAssertTrue(items.contains { $0.currencyCode == "Y" && $0.rate == 8.8 })
    }
}
