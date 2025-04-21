//
//  UseCaseManager.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/21/25.
//

import Foundation

final class UseCaseManager {
    func makeUseCases(
        currencyRepo: CurrencyItemRepositoryProtocol,
        favoriteRepo: FavoriteCurrencyRepository,
        cacheRepo: CachedCurrencyRepository,
        lastViewRepo: LastViewRepository
    ) -> (currencyUC: CurrencyItemUseCase,
        favoriteUC: FavoriteCurrencyUseCase,
        cacheUC: CachedCurrencyUseCase,
        lastViewUC: LastViewItemUseCase)
    {
        let currencyUC = CurrencyItemUseCase(repository: currencyRepo)
        let favoriteUC = FavoriteCurrencyUseCase(repository: favoriteRepo)
        let cacheUC = CachedCurrencyUseCase(repository: cacheRepo)
        let lastViewUC = LastViewItemUseCase(repository: lastViewRepo)
        return (currencyUC, favoriteUC, cacheUC, lastViewUC)
    }

}
