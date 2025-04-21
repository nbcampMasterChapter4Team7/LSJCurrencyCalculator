//
//  ExchangeRateViewModel.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/14/25.
//


import Foundation

final class ExchangeRateViewModel: ViewModelProtocol {

    // MARK: - Properties

    enum Action {
        case fetchCurrencyItem(base: String)
        case filterRates(searchText: String)
        case toggleFavorite(currencyCode: String)
        case saveLastViewItem
    }

    struct State {
        var currencyItems: [CurrencyItem] = []
        var errorMessage: String?
    }

    var action: ((Action) -> Void)?
    var onStateChange: ((State) -> Void)?

    private(set) var state = State() {
        didSet { onStateChange?(state) }
    }

    // 전체 데이터 보관(필터링 및 재정렬 위해)
    private var allDisplayItems: [CurrencyItem] = []

    // MARK: Proterties - UseCase

    private let currencyItemUseCase: CurrencyItemUseCase
    private let favoriteCurrencyUseCase: FavoriteCurrencyUseCase
    private let cachedCurrencyUseCase: CachedCurrencyUseCase
    private let lastViewItemUseCase: LastViewItemUseCase

    // MARK: - Initializer

    init(
        currencyItemUseCase: CurrencyItemUseCase,
        favoriteCurrencyUseCase: FavoriteCurrencyUseCase,
        cachedCurrencyUseCase: CachedCurrencyUseCase,
        lastViewItemUseCase: LastViewItemUseCase
    ) {
        self.currencyItemUseCase = currencyItemUseCase
        self.favoriteCurrencyUseCase = favoriteCurrencyUseCase
        self.cachedCurrencyUseCase = cachedCurrencyUseCase
        self.lastViewItemUseCase = lastViewItemUseCase

        self.action = { [weak self] action in
            guard let self = self else { return }
            switch action {
            case .fetchCurrencyItem(let base):
                self.fetchCurrencyItem(base: base)
            case .filterRates(let searchText):
                self.filterRates(with: searchText)
            case .toggleFavorite(let currencyCode):
                self.toggleFavorite(for: currencyCode)
            case .saveLastViewItem:
                self.saveLastViewItem()
            }
        }
    }

    private func fetchCurrencyItem(base: String) {
        currencyItemUseCase.fetchCurrencyItem(base: base) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let items):
                    var updateRates = self.compareAndUpdateRates(apiItems: items)
                    updateRates = self.favoriteCurrencyUseCase.updateFavoriteState(currencyitems: updateRates)
                    let sorted = updateRates.sorted { $0.currencyCode < $1.currencyCode }
                    self.allDisplayItems = sorted
                    self.state.currencyItems = self.favoriteCurrencyUseCase.applyFavoriteSorting(to: sorted)
                    self.state.errorMessage = nil

                case .failure:
                    self.failureFetchState()
                }
            }
        }
    }

    private func compareAndUpdateRates(apiItems: [CurrencyItem]) -> [CurrencyItem] {
        do {
            return try cachedCurrencyUseCase.compareAndUpdateRates(currencyItems: apiItems)
        } catch {
            self.failureFetchState()
            return apiItems
        }
    }

    private func failureFetchState() {
        self.allDisplayItems = []
        self.state.currencyItems = []
        self.state.errorMessage = "데이터를 불러올 수 없습니다."
    }


    private func saveLastViewItem() {
        let lastViewItem = LastViewItem(screenType: .exchange, currencyCode: nil)
        try? self.lastViewItemUseCase.saveLastViewItem(lastViewItem: lastViewItem)
    }

    private func toggleFavorite(for currencyCode: String) {
        do {
            try favoriteCurrencyUseCase.toggleFavorite(currencyCode: currencyCode)
        } catch {
            state.errorMessage = "즐겨찾기 변경에 실패했습니다."
        }
        allDisplayItems = favoriteCurrencyUseCase.updateFavoriteState(currencyitems: allDisplayItems)
        // 즐겨찾기 상태 재정렬
        state.currencyItems = favoriteCurrencyUseCase.applyFavoriteSorting(to: allDisplayItems)
    }

    private func filterRates(with searchText: String) {
        let trim = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        let filtered: [CurrencyItem]
        if trim.isEmpty {
            filtered = allDisplayItems
        } else {
            let up = trim.uppercased()
            filtered = allDisplayItems.filter { item in
                let code = item.currencyCode
                let country = CurrencyCountryMapper.countryName(for: code)
                return code.contains(up) || country.contains(up)
            }
        }
        state.currencyItems = favoriteCurrencyUseCase.applyFavoriteSorting(to: filtered)
    }
}
