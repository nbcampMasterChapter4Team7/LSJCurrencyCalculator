//
//  LastViewItemUseCase.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/18/25.
//

import Foundation

final class LastViewItemUseCase {
    private let repository: LastViewItemRepositoryProtocol
    
    init(repository: LastViewItemRepositoryProtocol) {
        self.repository = repository
    }
    
    func saveLastViewItem(lastViewItem: LastViewItem) throws {
        try repository.saveLastViewItem(lastViewItem: lastViewItem)
    }
    
    func loadLastViewItem() throws -> LastView? {
        try repository.loadLastViewItem()
    }
}
