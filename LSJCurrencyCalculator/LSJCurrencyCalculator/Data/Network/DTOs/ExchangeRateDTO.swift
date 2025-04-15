//
//  ExchangeRateDTO.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/14/25.
//

import Foundation

struct ExchangeRateDTO: Codable {
    let result: String
    let provider, documentation, termsOfUse: String
    let timeLastUpdateUnix: Int
    let timeLastUpdateUTC: String
    let timeNextUpdateUnix: Int
    let timeNextUpdateUTC: String
    let timeEOLUnix: Int
    let baseCode: String
    let rates: [String: Double]

    enum CodingKeys: String, CodingKey {
        case result, provider, documentation
        case termsOfUse = "terms_of_use"
        case timeLastUpdateUnix = "time_last_update_unix"
        case timeLastUpdateUTC = "time_last_update_utc"
        case timeNextUpdateUnix = "time_next_update_unix"
        case timeNextUpdateUTC = "time_next_update_utc"
        case timeEOLUnix = "time_eol_unix"
        case baseCode = "base_code"
        case rates
    }
}
