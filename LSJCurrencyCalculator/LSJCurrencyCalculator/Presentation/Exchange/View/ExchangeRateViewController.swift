//
//  ExchangeRateViewController.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/14/25.
//

import UIKit
import SnapKit
import Then

final class ExchangeRateViewController: UIViewController {

    private let viewModel: ExchangeRateViewModel
    private let lastViewItemUseCase: LastViewItemUseCase
    private let tableView = UITableView()
    private let searchBar = UISearchBar().then {
        $0.placeholder = "통화 검색"
//        $0.backgroundImage = UIImage() // 검색바 위/아래 테두리 제거
        $0.searchBarStyle = .minimal
    }

    init(
        viewModel: ExchangeRateViewModel,
        lastViewItemUseCase: LastViewItemUseCase
    ) {
        self.viewModel = viewModel
        self.lastViewItemUseCase = lastViewItemUseCase
        super.init(nibName: nil, bundle: nil)
        self.navigationItem.backButtonTitle = "환율 목록"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setStyles()
        setLayout()
        setUIComponents()
        bindViewModel()

        // 데이터를 요청하는 action 전달
        viewModel.action?(.fetchCurrencyItem(base: "USD"))
        viewModel.action?(.saveLastViewItem)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.action?(.saveLastViewItem)
    }

    private func setStyles() {
        view.backgroundColor = .background
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "환율 목록"
    }

    private func setLayout() {
        view.addSubviews(searchBar, tableView)
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func setUIComponents() {
        setSearchBar()
        setTableView()
    }

    private func setSearchBar() {
        searchBar.delegate = self
    }

    private func setTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ExchangeRateTableViewCell.self, forCellReuseIdentifier: ExchangeRateTableViewCell.identifier)
        tableView.rowHeight = 60
        tableView.separatorInset = .init(top: 0, left: 16, bottom: 0, right: 16)
    }

    private func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            DispatchQueue.main.async {
                if state.currencyItems.isEmpty {
                    let label = UILabel()
                    label.text = "검색 결과 없음"
                    label.textAlignment = .center
                    label.textColor = .gray
                    self?.tableView.backgroundView = label
                } else {
                    self?.tableView.backgroundView = nil
                }
                self?.tableView.reloadData()

                if let errorMessage = state.errorMessage {
                    self?.showAlert(message: errorMessage)
                }
            }
        }
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

extension ExchangeRateViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.state.currencyItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExchangeRateTableViewCell.identifier, for: indexPath) as? ExchangeRateTableViewCell else {
            return UITableViewCell()
        }

        let item = viewModel.state.currencyItems[indexPath.row]
        let code = item.currencyCode
        let rate = item.rate
        let direction = item.change
        let isFavorite = item.isFavorite
        cell.configure(with: code, rate: rate, direction: direction, isFavorite: isFavorite)
        cell.favoriteButtonAction = { [weak self] in
            self?.viewModel.action?(.toggleFavorite(currencyCode: code))
        }

        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRate = viewModel.state.currencyItems[indexPath.row]
        let calculatorViewModel = CalculatorViewModel(selectedCurrencyItem: selectedRate, lastViewItemUseCase: lastViewItemUseCase)
        let calculatorViewController = CalculatorViewController(viewModel: calculatorViewModel)
        navigationController?.pushViewController(calculatorViewController, animated: true)
    }
}

extension ExchangeRateViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // 뷰모델에 검색어 전달하여 필터링 실행
        viewModel.action?(.filterRates(searchText: searchText))
    }
}
