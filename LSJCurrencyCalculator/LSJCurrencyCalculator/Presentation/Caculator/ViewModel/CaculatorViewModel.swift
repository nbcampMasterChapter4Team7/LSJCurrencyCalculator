//
//  CaculatorViewModel.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/15/25.
//

import Foundation

final class CaculatorViewModel: ViewModelProtocol {

    enum Action {
        // 필요한 액션이 있다면 추가합니다.
    }

    struct State {
        // 필요하다면 상태 값을 정의합니다.
    }

    var action: ((Action) -> Void)?
    var state: State = State()

    // 선택한 환율 정보를 저장합니다.
    let selectedExchangeRate: ExchangeRate

    init(selectedExchangeRate: ExchangeRate) {
        self.selectedExchangeRate = selectedExchangeRate
    }
}

