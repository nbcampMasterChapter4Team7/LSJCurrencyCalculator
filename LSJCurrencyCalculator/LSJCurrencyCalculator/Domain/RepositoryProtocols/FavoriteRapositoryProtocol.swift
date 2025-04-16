//
//  FavoriteRapositoryProtocol.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/16/25.
//

import Foundation

protocol FavoriteRepositoryProtocol {
    func fetchAllFavorites() throws -> [Favorite]
    func addFavorite(currency: String, rate: Double) throws
    func removeFavorite(currency: String) throws
    func updateFavorite(currency: String, isFavorite: Bool) throws
}

