//
//  ManageFavoriteUseCase.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/16/25.
//

import Foundation

final class ManageFavoriteUseCase {
    private let repository: FavoriteRepositoryProtocol

    init(repository: FavoriteRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchFavorites() throws -> [Favorite] {
        return try repository.fetchAllFavorites()
    }

    func addFavorite(currency: String, rate: Double) throws {
        try repository.addFavorite(currency: currency, rate: rate)
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
    
    // 토글: 이미 즐겨찾기면 삭제, 아니면 추가 (추가 시 rate 정보가 필요)
    func toggleFavorite(currency: String, rate: Double) throws {
        if isFavorite(currency: currency) {
            try removeFavorite(currency: currency)
        } else {
            try addFavorite(currency: currency, rate: rate)
        }
    }
}

