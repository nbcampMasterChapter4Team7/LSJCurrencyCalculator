//
//  ExchangeRateViewController.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/14/25.
//

import UIKit

import SnapKit
import Then


final class ExchangeRateViewController: UIViewController, UITableViewDataSource {

    private let viewModel: ExchangeRateViewModel
    private let tableView = UITableView()

    init(viewModel: ExchangeRateViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        bindViewModel()
        
        // 데이터를 요청하는 action 전달
        viewModel.action?(.fetchRates(base: "USD"))
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.state.exchangeRates.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let rate = viewModel.state.exchangeRates[indexPath.row]
        cell.textLabel?.text = "\(rate.currency): \(String(format: "%.4f", rate.rate))"
        return cell
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}
