//
//  LastViewRepository.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/18/25.
//

import CoreData
import Foundation

final class LastViewRepository: LastViewItemRepositoryProtocol {
    
    private let persistentContainer: NSPersistentContainer
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }

    func saveLastViewItem(lastViewItem: LastViewItem) throws {
        let context = persistentContainer.viewContext
        let request = LastView.fetchRequest()

        let record: LastView
         if let existing = try context.fetch(request).first {
             // 이미 저장된 레코드가 있으면 덮어쓰기
             record = existing
         } else {
             // 없으면 새로 생성
             record = LastView(context: context)
         }
        record.screenType = lastViewItem.screenType.rawValue
        record.currencyCode = lastViewItem.currencyCode
        try context.save()
    }
    
    func loadLastViewItem() throws -> LastView? {
        let context = persistentContainer.viewContext
        let request = LastView.fetchRequest()
        let result = try context.fetch(request)
        
        if let target = result.first {
            return target
        }
        return nil
    }
    
}

