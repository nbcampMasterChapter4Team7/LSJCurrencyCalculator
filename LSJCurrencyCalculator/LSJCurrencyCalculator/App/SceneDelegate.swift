//
//  SceneDelegate.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/14/25.
//

import UIKit
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        // AppDelegatea 내의 Coredata Container 설정
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let container = appDelegate.persistentContainer

        // Data Layer
        let apiClient = APIClient.shared
//        let useFileMock = true
// MARK: TEST
//        let repository: CurrencyItemRepositoryProtocol = useFileMock
//            ? FileCurrencyItemRepository(filename: "sample.json")
//        : CurrencyItemRepository(apiClient: apiClient)
        let repository: CurrencyItemRepositoryProtocol = CurrencyItemRepository(apiClient: apiClient)

        let favoriteCurrencyRepository = FavoriteCurrencyRepository(persistentContainer: container)
        let cachedCurrencyRepository = CachedCurrencyRepository(persistentContainer: container)
        let lastViewRepository = LastViewRepository(persistentContainer: container)

        // Domain Layer
        let currencyItemUseCase = CurrencyItemUseCase(repository: repository)
        let favoriteCurrencyUseCase = FavoriteCurrencyUseCase(repository: favoriteCurrencyRepository)
        let cachedCurrencyUseCase = CachedCurrencyUseCase(repository: cachedCurrencyRepository)
        let lastViewItemUseCase = LastViewItemUseCase(repository: lastViewRepository)
        let fetchExchangeRatesUseCase = FetchExchangeRatesUseCase(repository: repository, cachedUseCase: cachedCurrencyUseCase)

        // Presentation Layer
        let viewModel = ExchangeRateViewModel(currencyItemUseCase: currencyItemUseCase, favoriteCurrencyUseCase: favoriteCurrencyUseCase, cachedCurrencyUseCase: cachedCurrencyUseCase, lastViewItemUseCase: lastViewItemUseCase, fetchExchangeRatesUseCase: fetchExchangeRatesUseCase)
        let exchangeRateVC = ExchangeRateViewController(viewModel: viewModel, lastViewItemUseCase: lastViewItemUseCase)
        exchangeRateVC.navigationItem.title = "환율 목록"
        exchangeRateVC.navigationItem.backButtonTitle = "환율 목록"

        // UINavigationController 세팅 (Large title 활성화)
        let navigationController = UINavigationController(rootViewController: exchangeRateVC)
        navigationController.navigationBar.prefersLargeTitles = true

        // Restore Last Viewed Screen
        if let last = try? lastViewItemUseCase.loadLastViewItem() {
            switch ScreenType(rawValue: last.screenType) {
            case .calculator:
                if let code = last.currencyCode {
                    let cachedCurrencys = try? cachedCurrencyUseCase.fetchAllCachedCurrency()
                    let timeUnix = Int(cachedCurrencys?.first?.timeUnix ?? 0)

                    let fetchCacheCurrency = try? cachedCurrencyUseCase.fetchCachedCurrency(currencyCode: code)

                    let selectedCurrencyItem = CurrencyItem(
                        currencyCode: fetchCacheCurrency?.currencyCode ?? "",
                        rate: fetchCacheCurrency?.rate ?? 0,
                        timeUnix: timeUnix,
                        change: RateChangeDirection(rawValue: fetchCacheCurrency!.change) ?? .none,
                        isFavorite: false
                    )

                    let calculatorViewModel = CalculatorViewModel(selectedCurrencyItem: selectedCurrencyItem, lastViewItemUseCase: lastViewItemUseCase)
                    let calculatorViewController = CalculatorViewController(viewModel: calculatorViewModel)
                    navigationController.pushViewController(calculatorViewController, animated: true)
                }
            default:
                break
            }
        } else {
            print("AASDFAS")
        }


        // UIWindow 세팅
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }


    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

