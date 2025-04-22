//
//  FavoriteCurrencyRepository.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/16/25.
//

import CoreData
import Foundation

final class FavoriteCurrencyRepository: FavoriteCurrencyRepositoryProtocol {
    
    private let persistentContainer: NSPersistentContainer
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }

    func fetchAllFavorites() throws -> [FavoriteCurrency] {
        let context = persistentContainer.viewContext
        let request = FavoriteCurrency.fetchRequest()
        return try context.fetch(request)
    }

    func addFavorite(currencyCode: String) throws {
        let context = persistentContainer.viewContext
        let request = FavoriteCurrency.fetchRequest()
        request.predicate = NSPredicate(format: "currencyCode == %@", currencyCode)
        let existing = try context.fetch(request).first
        let entity: FavoriteCurrency
        if let e = existing {
            entity = e
        } else {
            entity = FavoriteCurrency(context: context)
            entity.currencyCode = currencyCode
            entity.isFavorite = true
        }
        try context.save()
    }

    func removeFavorite(currencyCode: String) throws {
        let context = persistentContainer.viewContext
        let request = FavoriteCurrency.fetchRequest()
        request.predicate = NSPredicate(format: "currencyCode == %@", currencyCode)
        let results = try context.fetch(request)
        
        for obj in results {
            context.delete(obj)
        }
        try context.save()
    }
}

