//
//  FavoriteCurrencyRepositoryTests.swift
//  LSJCurrencyCalculatorTests
//
//  Created by yimkeul on 4/22/25.
//

import XCTest
import CoreData
@testable import LSJCurrencyCalculator

final class FavoriteCurrencyRepositoryTests: XCTestCase {
    var container: NSPersistentContainer!
    var repository: FavoriteCurrencyRepository!

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
        repository = FavoriteCurrencyRepository(persistentContainer: container)
    }
    


    override func tearDown() {
        repository = nil
        container = nil
        super.tearDown()
    }

    func testFetchAllFavorites_emptyInitially() throws {
        // Given: 아무 것도 저장되지 않은 상태

        // When
        let favorites = try repository.fetchAllFavorites()

        // Then
        XCTAssertTrue(favorites.isEmpty, "초기에는 즐겨찾기 목록이 비어 있어야 합니다.")
    }

    func testAddFavorite_thenFetchContainsIt() throws {
        // Given
        let code = "USD"
        
        // When
        try repository.addFavorite(currencyCode: code)
        let favorites = try repository.fetchAllFavorites()

        // Then
        XCTAssertEqual(favorites.count, 1, "하나의 즐겨찾기가 저장되어야 합니다.")
//        XCTAssertEqual(favorites.first?.currencyCode, code, "저장된 즐겨찾기 코드가 일치해야 합니다.")
//        XCTAssertTrue(favorites.first?.isFavorite ?? false, "isFavorite 플래그가 true여야 합니다.")
    }

    func testRemoveFavorite_removesOnlyMatching() throws {
        // Given: 두 개의 즐겨찾기 추가
        let codes = ["EUR", "JPY"]
        try codes.forEach { try repository.addFavorite(currencyCode: $0) }
        var all = try repository.fetchAllFavorites()
        XCTAssertEqual(all.count, 2, "두 개의 즐겨찾기가 저장되어야 합니다.")

        // When: "EUR" 즐겨찾기 삭제
        try repository.removeFavorite(currencyCode: "EUR")
        all = try repository.fetchAllFavorites()

        // Then
        XCTAssertEqual(all.count, 1, "하나의 즐겨찾기만 남아야 합니다.")
        XCTAssertEqual(all.first?.currencyCode, "JPY", "남아 있는 즐겨찾기가 'JPY'여야 합니다.")
    }

//    func testAddSameFavoriteTwice_resultsInTwoEntries() throws {
//        // Given
//        let code = "GBP"
//
//        // When
//        try repository.addFavorite(currencyCode: code)
//        try repository.addFavorite(currencyCode: code)
//        let favorites = try repository.fetchAllFavorites()
//
//        // Then
//        // CoreData 설정에 따라 중복 삽입이 허용되므로 count == 2 확인
//        XCTAssertEqual(favorites.count, 2, "동일 코드를 두 번 추가하면 두 개의 엔티티가 생성됩니다.")
//    }
}
