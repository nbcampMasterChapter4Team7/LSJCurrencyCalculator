//
//  LastViewItemRepositoryProtocol.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/18/25.
//

import Foundation

protocol LastViewItemRepositoryProtocol {
    func saveLastViewItem(lastViewItem: LastViewItem) throws
    func loadLastViewItem() throws -> LastView?
}
