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
    
    func fetchAllCachedCurrency() throws -> [CachedCurrency] {
        let context = persistentContainer.viewContext
        let request = CachedCurrency.fetchRequest()
        return try context.fetch(request)
    }

    func isNeedCompare(timeUnix: Int) throws -> Bool {
        let context = persistentContainer.viewContext
        let request = CachedCurrency.fetchRequest()
        request.fetchLimit = 1

        // 비교 필요
        guard let firstItem = try context.fetch(request).first else {
            return true
        }

        print("isNeedCompare :  \(firstItem.timeUnix) : \(timeUnix) --> \(firstItem.timeUnix != timeUnix)")

        return firstItem.timeUnix != timeUnix
    }

    func fetchCachedCurrency(currencyCode: String) throws -> CachedCurrency? {
        let context = persistentContainer.viewContext
        let request = CachedCurrency.fetchRequest()
        request.predicate = NSPredicate(format: "currencyCode == %@", currencyCode)
        let result = try context.fetch(request)

        if let target = result.first {
            return target
        }
        print("no fetch cache data")
        return nil
    }

    func compareCurrency(currencyCode: String, newCurrencyItem: CurrencyItem) throws -> RateChangeDirection {

        guard let cachedCurrencyItem = try fetchCachedCurrency(currencyCode: currencyCode) else {
            return .none
        }

        if abs(newCurrencyItem.rate - cachedCurrencyItem.rate) > 0.01 {
            return newCurrencyItem.rate > cachedCurrencyItem.rate ? .up : .down
        } else {
            return .none
        }
    }

    func saveCurrency(currencyCode: String, rate: Double, timeUnix: Int, change: String) throws {
        let context = persistentContainer.viewContext
        let request = CachedCurrency.fetchRequest()
        request.predicate = NSPredicate(format: "currencyCode == %@", currencyCode)
        let existing = try context.fetch(request).first

        let entity: CachedCurrency
        if let e = existing {
            entity = e
            print("TT : existing")
        } else {
            entity = CachedCurrency(context: context)
            entity.currencyCode = currencyCode
            print("TT : new save")
        }
        entity.rate = rate
        entity.timeUnix = Int64(timeUnix)
        entity.change = change
        print(entity.rate , entity.timeUnix, entity.change)
        try context.save()
    }
}
