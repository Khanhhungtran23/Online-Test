//
//  CurrencyPickerView.swift
//  Currency_Converter
//
//  Created by HƯNG TRẦN on 15/1/25.
//
import SwiftUI

struct CurrencyPickerView: View {
    let title: String
    let selection: Binding<Currency>
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            
            Picker(title, selection: selection) {
                ForEach(Currency.supportedCurrencies) { currency in
                    Text("\(currency.code) (\(currency.symbol))")
                        .tag(currency)
                }
            }
            .pickerStyle(MenuPickerStyle())
        }
    }
}
