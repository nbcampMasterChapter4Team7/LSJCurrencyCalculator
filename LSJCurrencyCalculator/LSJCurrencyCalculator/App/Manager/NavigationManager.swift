//
//  NavigationManager.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/21/25.
//

import Foundation
import UIKit

final class NavigationManager {
    
    func restoreLastViewedScreen(
        on navigationController: UINavigationController,
        cacheUseCase: CachedCurrencyUseCase,
        lastViewUseCase: LastViewItemUseCase,
        favoriteUseCase: FavoriteCurrencyUseCase
    ) {
        // 1) 마지막 뷰 정보 로드
        guard
            let last = try? lastViewUseCase.loadLastViewItem(),
            let screenType = ScreenType(rawValue: last.screenType),
            screenType == .calculator,
            let code = last.currencyCode
        else {
            return
        }

        // 2) 캐시에서 해당 통화 정보 로드
        guard
            let cachedList = try? cacheUseCase.fetchAllCachedCurrency(),
            let firstTime  = cachedList.first?.timeUnix,
            let cachedItem = try? cacheUseCase.fetchCachedCurrency(currencyCode: code)
        else {
            return
        }

        // 3) 도메인 모델 생성
        let item = CurrencyItem(
            currencyCode: cachedItem.currencyCode,
            rate:         cachedItem.rate,
            timeUnix:     Int(firstTime),
            change:       RateChangeDirection(rawValue: cachedItem.change) ?? .none,
            isFavorite:   favoriteUseCase.isFavorite(currencyCode: code)
        )

        // 4) 계산기 화면 생성 및 push
        let vm = CalculatorViewModel(
            selectedCurrencyItem: item,
            lastViewItemUseCase:  lastViewUseCase
        )
        let vc = CalculatorViewController(viewModel: vm)
        navigationController.pushViewController(vc, animated: false)
    }
}
