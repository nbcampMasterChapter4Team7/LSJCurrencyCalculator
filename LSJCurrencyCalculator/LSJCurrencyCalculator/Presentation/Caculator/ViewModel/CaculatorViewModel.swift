//
//  CaculatorViewModel.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/15/25.
//

import Foundation

final class CaculatorViewModel: ViewModelProtocol {
    
    enum Action {
        
    }
    
    struct State {
        
    }
    
    var action: ((Action) -> Void)?
    var state: State = State()
    
    
    
}
