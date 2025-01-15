//
//  CurrencyViewModel.swift
//  Currency_Converter
//
//  Created by HƯNG TRẦN on 15/1/25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class CurrencyViewModel: ObservableObject {
    @Published var amount: String = ""
    @Published var selectedFromCurrency: Currency = Currency.supportedCurrencies[0]
    @Published var selectedToCurrency: Currency = Currency.supportedCurrencies[1]
    @Published var convertedAmount: String = ""
    @Published var displayAmount: Double = 0
    @Published var targetAmount: Double = 0   
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var favoritePairs: [FavoritePair] = []
    
    private let service = ExchangeRateService()
    private let userDefaults = UserDefaults.standard
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadFavorites()
        setupAnimationTimer()
    }
    
    private func setupAnimationTimer() {
        Timer.publish(every: 0.016, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateDisplayAmount()
            }
            .store(in: &cancellables)
    }
    
    private func updateDisplayAmount() {
        let step = (targetAmount - displayAmount) * 0.1
        if abs(step) < 0.01 {
            displayAmount = targetAmount
        } else {
            displayAmount += step
        }
    }
    
    func toggleFavorite() {
        let pair = FavoritePair(
            fromCurrency: selectedFromCurrency.code,
            toCurrency: selectedToCurrency.code
        )
        
        if let index = favoritePairs.firstIndex(where: {
            $0.fromCurrency == pair.fromCurrency &&
            $0.toCurrency == pair.toCurrency
        }) {
            favoritePairs.remove(at: index)
        } else {
            favoritePairs.append(pair)
        }
        
        userDefaults.favoritePairs = favoritePairs
        HapticFeedback.impact(.medium)
    }
    
    private func loadFavorites() {
        favoritePairs = userDefaults.favoritePairs
    }
    
    private func validateInput() throws -> Double {
        guard !amount.isEmpty else {
            throw NetworkError.invalidFormat
        }
        
        let cleanedAmount = amount.replacingOccurrences(of: ",", with: ".")
            .trimmingCharacters(in: .whitespaces)
        
        guard let amountValue = Double(cleanedAmount) else {
            throw NetworkError.invalidFormat
        }
        
        // Kiểm tra số âm và số 0
        guard amountValue > 0 else {
            if amountValue < 0 {
                throw NetworkError.negativeAmount
            } else {
                throw NetworkError.zeroAmount
            }
        }
        
        guard selectedFromCurrency.code != selectedToCurrency.code else {
            throw NetworkError.sameCurrency
        }
        
        return amountValue
    }
    
    // Helper method để format số khi user đang nhập
    func formatAmount(_ newValue: String) {
        let filtered = newValue.filter { "0123456789.,".contains($0) }
        amount = filtered
    }
    
    func convertCurrency() async {
        do {
            let amountValue = try validateInput()
            isLoading = true
            errorMessage = nil
            convertedAmount = ""
            displayAmount = 0
            
            let response = try await service.fetchExchangeRate(from: selectedFromCurrency.code)
            guard let rate = response.rates[selectedToCurrency.code] else {
                throw NetworkError.unavailableRate
            }
            
            let result = amountValue * rate
            targetAmount = result
            
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            numberFormatter.maximumFractionDigits = 2
            numberFormatter.minimumFractionDigits = 2
            
            if let formattedResult = numberFormatter.string(from: NSNumber(value: result)) {
                convertedAmount = "\(formattedResult) \(selectedToCurrency.symbol)"
                HapticFeedback.notification(.success)
            } else {
                throw NetworkError.invalidFormat
            }
            
        } catch let error as NetworkError {
            errorMessage = error.message
            HapticFeedback.notification(.error)
        } catch {
            errorMessage = "Lỗi không xác định: \(error.localizedDescription)"
            HapticFeedback.notification(.error)
        }
        
        isLoading = false
    }
    
    // Swap currencies
    func swapCurrencies() {
        let temp = selectedFromCurrency
        selectedFromCurrency = selectedToCurrency
        selectedToCurrency = temp
        HapticFeedback.impact(.light)
        
        // Clear previous result
        convertedAmount = ""
        displayAmount = 0
        targetAmount = 0
    }
    
    // Select favorite pair
    func selectFavoritePair(_ pair: FavoritePair) {
        guard let fromCurrency = Currency.supportedCurrencies.first(where: { $0.code == pair.fromCurrency }),
              let toCurrency = Currency.supportedCurrencies.first(where: { $0.code == pair.toCurrency }) else {
            return
        }
        
        selectedFromCurrency = fromCurrency
        selectedToCurrency = toCurrency
        HapticFeedback.impact(.light)
        
        // Clear previous result
        convertedAmount = ""
        displayAmount = 0
        targetAmount = 0
    }
}
