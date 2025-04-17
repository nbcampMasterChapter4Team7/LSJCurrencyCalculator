//
//  ExchangeRateViewModel.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/14/25.
//


import Foundation

//final class ExchangeRateViewModel: ViewModelProtocol {
//
//    // Action 정의: ViewModel에 요청할 수 있는 작업
//    enum Action {
//        case fetchRates(base: String)
//        case filterRates(searchText: String)
//        case toggleFavorite(currencyCode: String)
//    }
//
//    // State 정의: View가 관찰할 상태 값
//    struct State {
//        var currencyItems: [CurrencyItem] = []
//        var errorMessage: String?
//    }
//
//    // 프로토콜 요구사항
//    var action: ((Action) -> Void)?
//    // State 변경 시 ViewController에서 상태를 관찰할 수 있도록 제공
//    var onStateChange: ((State) -> Void)?
//
//    private(set) var state = State() {
//        didSet {
//            self.onStateChange?(state)
//        }
//    }
//
//    // 전체 데이터를 보관하기 위한 프로퍼티 (필터링 용)
//    private var allExchangeRates: [CurrencyItem] = []
//
//    // UseCase 의존성
//    private let currencyItemUseCase: CurrencyItemUseCase
//    // 즐겨찾기 관련 UseCase (CoreData를 이용한 CRUD 기능을 포함)
//    private let favoriteCurrencyUseCase: FavoriteCurrencyUseCase
//    // 캐싱
//    private let cachedCurrencyUseCase: CachedCurrencyUseCase
//
//    init(currencyItemUseCase: CurrencyItemUseCase, favoriteCurrencyUseCase: FavoriteCurrencyUseCase, cachedCurrencyUseCase: CachedCurrencyUseCase) {
//        self.currencyItemUseCase = currencyItemUseCase
//        self.favoriteCurrencyUseCase = favoriteCurrencyUseCase
//        self.cachedCurrencyUseCase = cachedCurrencyUseCase
//
//        // action 클로저 구현
//        self.action = { [weak self] action in
//            switch action {
//            case .fetchRates(let base):
//                self?.fetchRates(base: base)
//            case .filterRates(let searchText):
//                self?.filterRates(with: searchText)
//            case .toggleFavorite(let currency):
//                self?.toggleFavorite(for: currency)
//            }
//        }
//    }
//
//    // 실제 데이터를 불러오는 함수
//    private func fetchRates(base: String) {
//        currencyItemUseCase.execute(base: base) { [weak self] result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let rates):
//                    let sortedRates = rates.sorted { $0.currencyCode < $1.currencyCode }
//                    var items: [CurrencyItem] = []
//                    for rate in sortedRates {
//                        let direction: RateChangeDirection
//                        do {
//                            direction = try self?.cachedCurrencyUseCase.compareCurrency(currencyCode: rate.currencyCode, newCurrencyItem: rate) ?? .none
//                        } catch {
//                            direction = .none
//                        }
//
//                        do {
//                            try self?.cachedCurrencyUseCase.cachingCurrency(currencyCode: rate.currencyCode, rate: rate.rate, date: Date())
//                        } catch {
//
//                        }
////                        items.append(CurrencyItem(currencyCode: rate.currencyCode, rate: rate.rate, change: direction, isFavorite: <#T##Bool#>))
//                    }
//
//
//
//
//
//                    self?.allExchangeRates = sortedRates
//                    self?.state.currencyItems = self?.applyFavoriteSorting(to: sortedRates) ?? []
//                    self?.state.errorMessage = nil
//                case .failure:
//                    self?.allExchangeRates = []
//                    self?.state.currencyItems = []
//                    self?.state.errorMessage = "데이터를 불러올 수 없습니다."
//                }
//            }
//        }
//    }
//
//    // 검색어를 전달받아 환율 데이터를 필터링하는 함수
//    func filterRates(with searchText: String) {
//        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
//        let filteredRates: [CurrencyItem]
//        if trimmed.isEmpty {
//            // 검색어가 비어있으면 전체 데이터 노출
//            filteredRates = allExchangeRates
//        } else {
//            let uppercasedSearch = trimmed.uppercased()
//            filteredRates = allExchangeRates.filter { rate in
//                return rate.currencyCode.contains(uppercasedSearch)
//                    || CurrencyCountryMapper.countryName(for: rate.currencyCode).contains(uppercasedSearch)
//            }
//        }
//        // 필터링 결과에도 즐겨찾기 정렬 적용
//        state.currencyItems = applyFavoriteSorting(to: filteredRates)
//    }
//
//    // 즐겨찾기 토글 처리 함수
//     private func toggleFavorite(for currencyCode: String) {
//        do {
//            try favoriteCurrencyUseCase.toggleFavorite(currencyCode: currencyCode)
//        } catch {
//            state.errorMessage = "즐겨찾기 변경에 실패했습니다."
//        }
//        // 즐겨찾기 상태가 변경되었으므로, 전체 데이터를 즐겨찾기 상태에 맞게 재정렬
//        state.currencyItems = applyFavoriteSorting(to: allExchangeRates)
//    }
//
//
//    // 즐겨찾기 상태 반영 정렬 함수:
//    // 즐겨찾기된 항목은 상단에 오고, 같은 그룹 내에서는 알파벳 순 정렬
//     private func applyFavoriteSorting(to rates: [CurrencyItem]) -> [CurrencyItem] {
//        return rates.sorted { left, right in
//            let leftFav = favoriteCurrencyUseCase.isFavorite(currencyCode: left.currencyCode)
//            let rightFav = favoriteCurrencyUseCase.isFavorite(currencyCode: right.currencyCode)
//            if leftFav != rightFav {
//                return leftFav && !rightFav
//            }
//            return left.currencyCode < right.currencyCode
//        }
//    }
//
//    func isFavorite(currencyCode: String) -> Bool {
//        return favoriteCurrencyUseCase.isFavorite(currencyCode: currencyCode)
//    }
//}

// ViewModelProtocol: action, onStateChange 등 프로토콜 임포트 필요
final class ExchangeRateViewModel: ViewModelProtocol {

    enum Action {
        case fetchRates(base: String)
        case filterRates(searchText: String)
        case toggleFavorite(currencyCode: String)
    }

    // 화면에 표시할 모델
//    struct DisplayItem {
//        let currencyItem: CurrencyItem
//        let direction: RateChangeDirection
//    }

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
                case .success(let rates):
                    let sortedRates = rates.sorted { $0.currencyCode < $1.currencyCode }
                    var items: [CurrencyItem] = []
                    guard let firstItem = sortedRates.first else {
                        NSLog("TT : firstItem 없음")
                        return
                    }
                    do {
                        if try self.cachedCurrencyUseCase.isNeedCompare(timeUnix: firstItem.timeUnix) {
                            // 서로 timeUTC가 다른경우에는 비교하기
                            // 끝나고 데이터 저장.
                            for rate in sortedRates {
                                let dir: RateChangeDirection
                                do {
                                    dir = try self.cachedCurrencyUseCase.compareCurrency(currencyCode: rate.currencyCode, newCurrencyItem: rate)
                                } catch {
                                    dir = .none
                                }
                                
                                do {
                                    try self.cachedCurrencyUseCase.saveCurrency(currencyCode: rate.currencyCode, rate: rate.rate, timeUnix: firstItem.timeUnix)
                                } catch {
                                    // 저장 실패
                                    print("저장 실패")
                                }
                                items.append(CurrencyItem(currencyCode: rate.currencyCode, rate: rate.rate, timeUnix: firstItem.timeUnix, change: dir, isFavorite: false))
                            }
                            
                        } else {
                            items = sortedRates
                        }
                        self.allDisplayItems = items
                        self.state.currencyItems = self.applyFavoriteSorting(to: items)
                        self.state.errorMessage = nil
                    } catch {
                        print("비교 실패")
                        self.allDisplayItems = []
                        self.state.currencyItems = []
                        self.state.errorMessage = "데이터를 불러올 수 없습니다."
                    }
                case .failure:
                    self.allDisplayItems = []
                    self.state.currencyItems = []
                    self.state.errorMessage = "데이터를 불러올 수 없습니다."
                }
            }
        }
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
