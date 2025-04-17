//
//  FavoriteCurrencyUseCase.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/16/25.
//

import Foundation

final class FavoriteCurrencyUseCase {
    private let repository: FavoriteCurrencyRepositoryProtocol

    init(repository: FavoriteCurrencyRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchFavorites() throws -> [FavoriteCurrency] {
        return try repository.fetchAllFavorites()
    }

    func addFavorite(currencyCode: String) throws {
        try repository.addFavorite(currencyCode: currencyCode)
    }

    func removeFavorite(currencyCode: String) throws {
        try repository.removeFavorite(currencyCode: currencyCode)
    }

    func updateFavorite(currencyCode: String, isFavorite: Bool) throws {
        try repository.updateFavorite(currencyCode: currencyCode, isFavorite: isFavorite)
    }
    
    // 즐겨찾기 여부 확인
    func isFavorite(currencyCode: String) -> Bool {
        let favorites = (try? fetchFavorites()) ?? []
        return favorites.contains { $0.currencyCode == currencyCode }
    }
    
    // 토글: 이미 즐겨찾기면 삭제, 아니면 추가
    func toggleFavorite(currencyCode: String) throws {
        if isFavorite(currencyCode: currencyCode) {
            try removeFavorite(currencyCode: currencyCode)
        } else {
            try addFavorite(currencyCode: currencyCode)
        }
    }
}

