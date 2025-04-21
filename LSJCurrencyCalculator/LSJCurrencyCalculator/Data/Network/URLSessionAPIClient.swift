//
//  URLSessionAPIClient.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/14/25.
//

import Foundation

final class URLSessionAPIClient: APIClientProtocol {

    func request<T: Decodable>(
        _ endpoint: Endpoint,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        let task = URLSession.shared.dataTask(with: endpoint.urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: 0)))
                return
            }
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

