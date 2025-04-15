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
    private let tableView = ExchangeRateTableView()
    
    private let searchBar = UISearchBar().then {
        $0.placeholder = "통화 검색"
        $0.backgroundImage = UIImage() // 검색바 위/아래 테두리 제거
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
        searchBar.delegate = self
        // 데이터를 요청하는 action 전달
        viewModel.action?(.fetchRates(base: "USD"))
    }

    
    private func setStyles() {
        view.backgroundColor = .systemBackground
    }
    
    
    private func setupLayout() {
        view.addSubviews(searchBar,tableView)
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        
        tableView.dataSource = self
        tableView.separatorInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            DispatchQueue.main.async {
                // 결과가 없으면 backgroundView에 "검색 결과 없음" 표시
                if state.exchangeRates.isEmpty {
                    let label = UILabel()
                    label.text = "검색 결과 없음"
                    label.textAlignment = .center
                    label.textColor = .gray
                    self?.tableView.backgroundView = label
                } else {
                    self?.tableView.backgroundView = nil
                }
                self?.tableView.reloadData()
                
                // 오류가 있을 경우 alert 표시
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

extension ExchangeRateViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // 뷰모델에 검색어 전달하여 필터링 실행
        viewModel.filterRates(with: searchText)
    }
    
    // 검색 취소시 전체 목록 노출 (선택사항)
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        viewModel.filterRates(with: "")
        searchBar.resignFirstResponder()
    }
}
