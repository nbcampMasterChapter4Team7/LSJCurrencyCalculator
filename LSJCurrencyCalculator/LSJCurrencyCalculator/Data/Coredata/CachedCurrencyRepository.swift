//
//  CachedCurrencyRepository.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/17/25.
//

import CoreData
import Foundation

final class CachedCurrencyRepository: CachedCurrencyRepositoryProtocol {

    private let persistentContainer: NSPersistentContainer

    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }


    func fetchCachedCurrency(currencyCode: String, date: Date) throws -> CachedCurrency? {
        let context = persistentContainer.viewContext
        let request = CachedCurrency.fetchRequest()

        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "currencyCode == %@", currencyCode),
            NSPredicate(format: "date >= %@ AND date < %@", startOfDay as NSDate, endOfDay as NSDate)
            ])
        request.fetchLimit = 1

        return try context.fetch(request).first

    }

    func compareCurrency(currencyCode: String, newCurrencyItem: CurrencyItem) throws -> RateChangeDirection {
        guard let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()),
            let previousCurrencyItem = try fetchCachedCurrency(currencyCode: currencyCode, date: yesterday) else {
            return .none
        }

        if abs(newCurrencyItem.rate - previousCurrencyItem.rate) > 0.01 {
            return newCurrencyItem.rate > previousCurrencyItem.rate ? .up : .down
        } else {
            return .none
        }
    }

    func cachingCurrency(currencyCode: String, rate: Double, date: Date) throws {
        let context = persistentContainer.viewContext
        let startOfDay = Calendar.current.startOfDay(for: date)
        let request = CachedCurrency.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "currencyCode == %@", currencyCode),
            NSPredicate(format: "date == %@", startOfDay as NSDate)
        ])
        let results = try context.fetch(request)
        
        if let target = results.first {
            target.date = startOfDay
            target.rate = rate
            try context.save()
        }
    }


}
