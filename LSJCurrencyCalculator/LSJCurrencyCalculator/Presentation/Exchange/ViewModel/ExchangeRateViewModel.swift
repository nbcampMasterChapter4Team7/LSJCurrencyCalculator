//
//  ExchangeRateViewModel.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/14/25.
//


import Foundation

final class ExchangeRateViewModel: ViewModelProtocol {

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

    private let currencyItemUseCase: CurrencyItemUseCase
    private let favoriteCurrencyUseCase: FavoriteCurrencyUseCase
    private let cachedCurrencyUseCase: CachedCurrencyUseCase
    private let lastViewItemUseCase: LastViewItemUseCase

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
            case .toggleFavorite(let code):
                self.toggleFavorite(for: code)
            case .saveLastViewItem:
                self.saveLastViewItem()
            }
        }
    }

    private func saveLastViewItem() {
        do {
            let lastViewItem = LastViewItem(
                screenType: .exchange,
                currencyCode: nil
            )
            try self.lastViewItemUseCase.saveLastViewItem(lastViewItem: lastViewItem)
        } catch {
            print("Last view save failed: \(error)")
        }
    }

    private func fetchCurrencyItem(base: String) {
        currencyItemUseCase.fetchCurrencyItem(base: base) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let items):
                    let updateRates = self.compareAndUpdateRates(apiItems: items)
                    let sorted = updateRates.sorted { $0.currencyCode < $1.currencyCode }
                    self.allDisplayItems = sorted
                    self.state.currencyItems = self.applyFavoriteSorting(to: sorted)
                    self.state.errorMessage = nil
                    
                case .failure:
                    self.failureFetchState()
                }
            }
        }
    }
    
    private func compareAndUpdateRates(apiItems: [CurrencyItem]) -> [CurrencyItem] {
        do {
          return  try cachedCurrencyUseCase.compareAndUpdateRates(currencyItems: apiItems)
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

    func filterRates(with searchText: String) {
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
        state.currencyItems = applyFavoriteSorting(to: filtered)
    }

    private func toggleFavorite(for code: String) {
        do {
            try favoriteCurrencyUseCase.toggleFavorite(currencyCode: code)
        } catch {
            state.errorMessage = "즐겨찾기 변경에 실패했습니다."
        }
        // 즐겨찾기 상태 재정렬
        state.currencyItems = applyFavoriteSorting(to: allDisplayItems)
    }

    private func applyFavoriteSorting(to items: [CurrencyItem]) -> [CurrencyItem] {
        return items.sorted { a, b in
            let aFav = favoriteCurrencyUseCase.isFavorite(currencyCode: a.currencyCode)
            let bFav = favoriteCurrencyUseCase.isFavorite(currencyCode: b.currencyCode)
            if aFav != bFav {
                return aFav
            }
            return a.currencyCode < b.currencyCode
        }
    }

    func isFavorite(currencyCode: String) -> Bool {
        return favoriteCurrencyUseCase.isFavorite(currencyCode: currencyCode)
    }
}
