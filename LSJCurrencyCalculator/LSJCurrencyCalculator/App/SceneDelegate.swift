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
        
        // MARK: TEST
        /// true / false로 이전 api data 불러오기
        let useFileMock = false
        let testCurrencyRepo: CurrencyItemRepositoryProtocol = useFileMock ? FileCurrencyItemRepository(filename: "sample.json") : RepositoryManager().makeRepositories(using: container).currencyRepo
        
        // Data Layer
        let repositorys = RepositoryManager().makeRepositories(using: container)

        // Domain Layer
        let useCases = UseCaseManager().makeUseCases(
            currencyRepo: /*repositorys.currencyRepo,*/ testCurrencyRepo,
            favoriteRepo: repositorys.favoriteRepo,
            cacheRepo: repositorys.cacheRepo,
            lastViewRepo: repositorys.lastViewRepo
        )

        // Presentation Layer
        let exchangeRateViewModel = ExchangeRateViewModel(
            currencyItemUseCase: useCases.currencyUC,
            favoriteCurrencyUseCase: useCases.favoriteUC,
            cachedCurrencyUseCase: useCases.cacheUC,
            lastViewItemUseCase: useCases.lastViewUC
        )

        let exchangeRateViewController = ExchangeRateViewController(
            viewModel: exchangeRateViewModel,
            lastViewItemUseCase: useCases.lastViewUC
        )

        let navigationController = UINavigationController(rootViewController: exchangeRateViewController)

        // Restore Last Viewed Screen
        NavigationManager().restoreLastViewedScreen(
            on: navigationController,
            cacheUseCase: useCases.cacheUC,
            lastViewUseCase: useCases.lastViewUC,
            favoriteUseCase: useCases.favoriteUC
        )

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

