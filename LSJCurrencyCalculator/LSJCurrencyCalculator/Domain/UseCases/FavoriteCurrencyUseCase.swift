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

    func addFavorite(currency: String) throws {
        try repository.addFavorite(currency: currency)
    }

    func removeFavorite(currency: String) throws {
        try repository.removeFavorite(currency: currency)
    }

    func updateFavorite(currency: String, isFavorite: Bool) throws {
        try repository.updateFavorite(currency: currency, isFavorite: isFavorite)
    }
    
    // 즐겨찾기 여부 확인
    func isFavorite(currency: String) -> Bool {
        let favorites = (try? fetchFavorites()) ?? []
        return favorites.contains { $0.currency == currency }
    }
    
    // 토글: 이미 즐겨찾기면 삭제, 아니면 추가
    func toggleFavorite(currency: String) throws {
        if isFavorite(currency: currency) {
            try removeFavorite(currency: currency)
        } else {
            try addFavorite(currency: currency)
        }
    }
}

