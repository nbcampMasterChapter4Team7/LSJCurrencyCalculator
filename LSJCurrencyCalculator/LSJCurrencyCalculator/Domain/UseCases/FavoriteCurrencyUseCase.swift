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
}

// ViewModel에서 사용
extension FavoriteCurrencyUseCase {
    func isFavorite(currencyCode: String) -> Bool {
        let favorites = (try? fetchFavorites()) ?? []
        return favorites.contains { $0.currencyCode == currencyCode }
    }
    
    func updateFavoriteState(currencyitems: [CurrencyItem]) -> [CurrencyItem] {
        return currencyitems.map { item in
            var copy = item
            copy.isFavorite = isFavorite(currencyCode: item.currencyCode)
            return copy
        }
    }

    func toggleFavorite(currencyCode: String) throws {
        if isFavorite(currencyCode: currencyCode) {
            try removeFavorite(currencyCode: currencyCode)
        } else {
            try addFavorite(currencyCode: currencyCode)
        }
    }
    
    func applyFavoriteSorting(to items: [CurrencyItem]) -> [CurrencyItem] {
        return items.sorted {
            if isFavorite(currencyCode: $0.currencyCode) != isFavorite(currencyCode: $1.currencyCode) {
                return isFavorite(currencyCode: $0.currencyCode)
            }
            return $0.currencyCode < $1.currencyCode
        }
    }
}

