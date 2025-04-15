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
        setupLayout()
        // 데이터를 요청하는 action 전달
        viewModel.action?(.fetchRates(base: "USD"))
    }

    
    
    private func setupLayout() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
