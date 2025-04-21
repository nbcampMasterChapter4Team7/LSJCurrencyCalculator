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

        print("[DEBUG] : isNeedCompare :  \(firstItem.timeUnix) : \(timeUnix) --> \(firstItem.timeUnix != timeUnix)")

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
        print("[DEBUG] : no fetch cache data")
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
            print("[DEBUG] : existing cache")
        } else {
            entity = CachedCurrency(context: context)
            entity.currencyCode = currencyCode
            print("[DEBUG] : new save cache")
        }
        entity.rate = rate
        entity.timeUnix = Int64(timeUnix)
        entity.change = change
        print(entity.rate , entity.timeUnix, entity.change)
        try context.save()
    }
    
    func compareAndUpdateRates(currencyItems: [CurrencyItem]) throws -> [CurrencyItem] {
        guard let first = currencyItems.first else { return [] }
        let currentTime = first.timeUnix
        if try isNeedCompare(timeUnix: currentTime) {
            // 시간 다르면 하나씩 비교 후 캐시 저장
            var result: [CurrencyItem] = []
            for item in currencyItems {
                let direction = try compareCurrency(
                    currencyCode: item.currencyCode,
                    newCurrencyItem: item
                )
                // 캐시에 저장
                try saveCurrency(
                    currencyCode: item.currencyCode,
                    rate: item.rate,
                    timeUnix: currentTime,
                    change: direction.rawValue
                )
                // Domain 엔티티 생성
                result.append(
                    CurrencyItem(
                        currencyCode: item.currencyCode,
                        rate: item.rate,
                        timeUnix: currentTime,
                        change: direction,
                        isFavorite: item.isFavorite
                    )
                )
            }
            return result
        } else {
            // 시간 같으면 캐시된 모든 환율을 로드
            let cached = try fetchAllCachedCurrency()
            return cached.map { c in
                CurrencyItem(
                    currencyCode: c.currencyCode,
                    rate: c.rate,
                    timeUnix: currentTime,
                    change: RateChangeDirection(rawValue: c.change) ?? .none,
                    isFavorite: false
                )
            }
        }
    }
}
