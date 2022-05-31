//
//  NetworkService.swift
//  MCBCurMVC
//
//  Created by Grigory Stolyarov on 29.05.2022.
//

import Foundation

protocol NetworkServiceProtocol {
    
    func getExchangeRates(completion: @escaping (Result<ExchangeRateResult, Error>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    
    func getExchangeRates(completion: @escaping (Result<ExchangeRateResult, Error>) -> Void) {
        
        let parameters: [String: Any] = [
            "r": "BEYkZbmV",
            "d": "563B4852-6D4B-49D6-A86E-B273DD520FD2",
            "t": "ExchangeRates",
            "v": 44
        ]
        guard let parametersString = parameters.percentEncoded(),
              let url = URL(string: "https://alpha.as50464.net:29870/moby-pre-44/core?" + parametersString)
        else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Test GeekBrains iOS 3.0.0.182 (iPhone 11; iOS 14.4.1; Scale/2.00; Private)",
                         forHTTPHeaderField: "User-Agent")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let parametersJSON: [String: Any] = [
            "uid": "563B4852-6D4B-49D6-A86E-B273DD520FD2",
            "type": "ExchangeRates",
            "rid": "BEYkZbmV"
        ]
        if let jsonData = try? JSONSerialization.data(withJSONObject: parametersJSON) {
            request.httpBody = jsonData
        }
        
        URLSession.shared.dataTask(with: request) {data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(ExchangeRateResult.self, from: data!)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
}
