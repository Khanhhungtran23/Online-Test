//
//  ExchangeRateResponse.swift
//  Currency_Converter
//
//  Created by HƯNG TRẦN on 15/1/25.
//

struct ExchangeRateResponse: Codable {
    let rates: [String: Double]
    let base: String
    let date: String
    
    enum CodingKeys: String, CodingKey {
        case rates = "rates"
        case base = "base"
        case date = "date"
    }
}
