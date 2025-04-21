//
//  FavoriteCurrencyRepositoryProtocol.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/16/25.
//

import Foundation

protocol FavoriteCurrencyRepositoryProtocol {
    func fetchAllFavorites() throws -> [FavoriteCurrency]
    func addFavorite(currencyCode: String) throws
    func removeFavorite(currencyCode: String) throws
}

