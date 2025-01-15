//
//  ExchangeRateService.swift
//  Currency_Converter
//
//  Created by HƯNG TRẦN on 15/1/25.
//

import Foundation

class ExchangeRateService {
    private let baseURL = "https://api.exchangerate-api.com/v4/latest/"
    
    func fetchExchangeRate(from baseCurrency: String) async throws -> ExchangeRateResponse {
        guard let url = URL(string: baseURL + baseCurrency) else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw NetworkError.invalidResponse
            }
            
            let decoder = JSONDecoder()
            return try decoder.decode(ExchangeRateResponse.self, from: data)
        } catch let decodingError as DecodingError {
            throw NetworkError.decodingError
        } catch {
            throw NetworkError.networkError(error)
        }
    }
}
