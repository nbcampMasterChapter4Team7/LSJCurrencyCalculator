//
//  RepositoryManager.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/21/25.
//

import Foundation
import CoreData

final class RepositoryManager {
    func makeRepositories(using container: NSPersistentContainer) -> (currencyRepo: CurrencyItemRepositoryProtocol,
        favoriteRepo: FavoriteCurrencyRepository,
        cacheRepo: CachedCurrencyRepository,
        lastViewRepo: LastViewRepository)
    {
//        let apiClient = URLSessionAPIClient()
        let apiClient = AlamofireAPIClient()
        let currencyRepo = CurrencyItemRepository(apiClient: apiClient)
        let favoriteRepo = FavoriteCurrencyRepository(persistentContainer: container)
        let cacheRepo = CachedCurrencyRepository(persistentContainer: container)
        let lastViewRepo = LastViewRepository(persistentContainer: container)
        return (currencyRepo, favoriteRepo, cacheRepo, lastViewRepo)
    }
}
