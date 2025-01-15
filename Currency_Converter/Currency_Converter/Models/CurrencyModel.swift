//
//  CurrencyModel.swift.swift
//  Currency_Converter
//
//  Created by HƯNG TRẦN on 15/1/25.
//

import Foundation

struct Currency: Identifiable, Hashable, Equatable {
    let id = UUID()
    let code: String
    let name: String
    let symbol: String  
    
    // implement Equatable
    static func == (lhs: Currency, rhs: Currency) -> Bool {
        return lhs.id == rhs.id &&
               lhs.code == rhs.code &&
               lhs.name == rhs.name &&
               lhs.symbol == rhs.symbol
    }
    
    static let supportedCurrencies: [Currency] = [
        Currency(code: "USD", name: "US Dollar", symbol: "$"),
        Currency(code: "EUR", name: "Euro", symbol: "€"),
        Currency(code: "JPY", name: "Japanese Yen", symbol: "¥"),
        Currency(code: "GBP", name: "British Pound", symbol: "£")
    ]
}

