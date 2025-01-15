//
//  FavoritePair.swift
//  Currency_Converter
//
//  Created by HƯNG TRẦN on 15/1/25.
//

import Foundation

struct FavoritePair: Identifiable, Codable {
    let id: UUID
    let fromCurrency: String
    let toCurrency: String
    
    init(fromCurrency: String, toCurrency: String) {
        self.id = UUID()
        self.fromCurrency = fromCurrency
        self.toCurrency = toCurrency
    }
}

