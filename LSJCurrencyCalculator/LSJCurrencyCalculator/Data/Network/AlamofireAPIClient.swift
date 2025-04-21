//
//  AlamofireAPIClient.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/21/25.
//

import Foundation

import Alamofire

/// Alamofire 기반의 네트워크 클라이언트
final class AlamofireAPIClient: APIClientProtocol {
    
    /// 테스트 시점에 MockSession을 주입할 수 있도록, Session을 DI
    private let session: Session
    
    init(session: Session = .default) {
        self.session = session
    }
    
    func request<T: Decodable>(
        _ endpoint: Endpoint,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        session
            .request(endpoint.urlRequest)        // URLRequest에서 HTTPMethod, headers도 가져옴
            .validate()                         // 상태코드 200~299만 통과
            .responseDecodable(of: T.self) { res in
                switch res.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
