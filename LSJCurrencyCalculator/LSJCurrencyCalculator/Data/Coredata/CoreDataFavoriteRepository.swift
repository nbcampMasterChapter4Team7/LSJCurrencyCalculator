//
//  CoreDataFavoriteRepository.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/16/25.
//

import CoreData
import Foundation

final class CoreDataFavoriteRepository: FavoriteRepositoryProtocol {
    
    private let persistentContainer: NSPersistentContainer
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }

    func fetchAllFavorites() throws -> [Favorite] {
        let context = persistentContainer.viewContext
        let request = Favorite.fetchRequest() // NSFetchRequest<Favorite>
        return try context.fetch(request)
    }

    func addFavorite(currency: String, rate: Double) throws {
        let context = persistentContainer.viewContext
        let favorite = Favorite(context: context)
        favorite.uuid = UUID()
        favorite.currency = currency
        favorite.rate = rate
        favorite.isFavorite = true
        try context.save()
    }

    func removeFavorite(currency: String) throws {
        let context = persistentContainer.viewContext
        let request = Favorite.fetchRequest()
        request.predicate = NSPredicate(format: "currency == %@", currency)
        let results = try context.fetch(request)
        
        for obj in results {
            context.delete(obj)
        }
        try context.save()
    }

    func updateFavorite(currency: String, isFavorite: Bool) throws {
        let context = persistentContainer.viewContext
        let request = Favorite.fetchRequest()
        request.predicate = NSPredicate(format: "currency == %@", currency)
        let results = try context.fetch(request)
        
        if let target = results.first {
            target.isFavorite = isFavorite
            try context.save()
        }
    }
}

