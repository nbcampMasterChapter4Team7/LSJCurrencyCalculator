//
//  ExchangeRateViewModel.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/14/25.
//


import Foundation

final class ExchangeRateViewModel: ViewModelProtocol {

    enum Action {
        case fetchRates(base: String)
        case filterRates(searchText: String)
        case toggleFavorite(currencyCode: String)
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

    init(
        currencyItemUseCase: CurrencyItemUseCase,
        favoriteCurrencyUseCase: FavoriteCurrencyUseCase,
        cachedCurrencyUseCase: CachedCurrencyUseCase
    ) {
        self.currencyItemUseCase = currencyItemUseCase
        self.favoriteCurrencyUseCase = favoriteCurrencyUseCase
        self.cachedCurrencyUseCase = cachedCurrencyUseCase

        self.action = { [weak self] action in
            guard let self = self else { return }
            switch action {
            case .fetchRates(let base):
                self.fetchRates(base: base)
            case .filterRates(let searchText):
                self.filterRates(with: searchText)
            case .toggleFavorite(let code):
                self.toggleFavorite(for: code)
            }
        }
    }

    private func fetchRates(base: String) {
        currencyItemUseCase.execute(base: base) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let currencyItems):
                    var items: [CurrencyItem] = []
                    guard let firstItem = currencyItems.first else {
                        NSLog("TT : firstItem 없음")
                        return
                    }
                    do {
                        // 서로 timeUTC가 다른경우에는 비교하기
                        if try self.cachedCurrencyUseCase.isNeedCompare(timeUnix: firstItem.timeUnix) {
                            // 끝나고 데이터 저장.
                            for currencyItem in currencyItems {
                                var dir: RateChangeDirection = .none
                                do {
                                    dir = try self.cachedCurrencyUseCase.compareCurrency(currencyCode: currencyItem.currencyCode, newCurrencyItem: currencyItem)
                                } catch {
                                    print("비교 실패")
                                }

                                do {
                                    try self.cachedCurrencyUseCase.saveCurrency(currencyCode: currencyItem.currencyCode, rate: currencyItem.rate, timeUnix: firstItem.timeUnix, change: dir.rawValue)
                                } catch {
                                    print("저장 실패")
                                }
                                items.append(CurrencyItem(currencyCode: currencyItem.currencyCode, rate: currencyItem.rate, timeUnix: firstItem.timeUnix, change: dir, isFavorite: false))
                            }
                        } else {
                            // 서로 timeUTC가 같은 경우 CoreData에서 캐시데이터 불러오기
                            do {
                                let cachedCurrencys = try self.cachedCurrencyUseCase.fetchAllCachedCurrency()
                                items = cachedCurrencys.compactMap { cachedCurrency in
                                    CurrencyItem(currencyCode: cachedCurrency.currencyCode, rate: cachedCurrency.rate, timeUnix: firstItem.timeUnix, change: RateChangeDirection(rawValue: cachedCurrency.change) ?? .none, isFavorite: false)
                                }
                            } catch {
                                print("TT : checkPoint")
                                // 캐시데이터도 없는 경우 API 데이터 렌더링
                                items = currencyItems
                            }
                        }
                        let sortedRates = items.sorted { $0.currencyCode < $1.currencyCode }
                        self.allDisplayItems = sortedRates
                        self.state.currencyItems = self.applyFavoriteSorting(to: sortedRates)
                        self.state.errorMessage = nil
                    } catch {
                        print("비교 실패")
                        self.failureFetchState()
                    }
                case .failure:
                    self.failureFetchState()
                }
            }
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
