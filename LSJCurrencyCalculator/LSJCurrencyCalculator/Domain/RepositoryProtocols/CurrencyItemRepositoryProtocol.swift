//
//  CurrencyItemRepositoryProtocol.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/14/25.
//

import Foundation

protocol CurrencyItemRepositoryProtocol {
    func fetchCurrencyItem(base: String, completion: @escaping (Result<[CurrencyItem], Error>) -> Void) throws
}
