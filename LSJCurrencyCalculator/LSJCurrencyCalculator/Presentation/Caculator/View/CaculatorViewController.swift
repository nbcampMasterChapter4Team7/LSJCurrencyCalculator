//
//  CaculatorViewController.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/15/25.
//

import UIKit

import SnapKit
import Then

final class CaculatorViewController: UIViewController {
    
    private let viewModel: CaculatorViewModel
    
    init(viewModel: CaculatorViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "환율 계산기"
        setStyles()
    }
    
    private func setStyles() {
        view.backgroundColor = .systemBackground
    }
}
