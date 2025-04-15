//
//  ExchangeRateViewController.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/14/25.
//

import UIKit

import SnapKit
import Then


final class ExchangeRateViewController: UIViewController{

    private let viewModel: ExchangeRateViewModel
    private let tableView = ExchangeRateTableView()
    
    private let searchBar = UISearchBar().then {
        $0.placeholder = "통화 검색"
        $0.backgroundImage = UIImage()
        // addView를 했을때 위 아래 테두리 없애기위해 사용
    }

    init(viewModel: ExchangeRateViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setStyles()
        setupLayout()
        // 데이터를 요청하는 action 전달
        viewModel.action?(.fetchRates(base: "USD"))
    }

    
    private func setStyles() {
        view.backgroundColor = .systemBackground
    }
    
    
    private func setupLayout() {
        view.addSubviews(tableView, searchBar)
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        
        tableView.dataSource = self
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            if let errorMessage = state.errorMessage {
                self?.showAlert(message: errorMessage)
            } else {
                self?.tableView.reloadData()
            }
        }
    }

    

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

extension ExchangeRateViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.state.exchangeRates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExchangeRateTableViewCell.identifier, for: indexPath) as? ExchangeRateTableViewCell else {
            return UITableViewCell()
        }

        let rate = viewModel.state.exchangeRates[indexPath.row]
        cell.configure(with: rate.currency, rate: rate.rate)
        return cell
    }

}
