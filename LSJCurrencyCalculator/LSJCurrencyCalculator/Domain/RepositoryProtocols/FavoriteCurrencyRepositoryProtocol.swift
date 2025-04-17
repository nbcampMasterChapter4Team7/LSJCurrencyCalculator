//
//  FavoriteCurrencyRepositoryProtocol.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/16/25.
//

import Foundation

protocol FavoriteCurrencyRepositoryProtocol {
    func fetchAllFavorites() throws -> [FavoriteCurrency]
    func addFavorite(currency: String, rate: Double) throws
    func removeFavorite(currency: String) throws
    func updateFavorite(currency: String, isFavorite: Bool) throws
}

