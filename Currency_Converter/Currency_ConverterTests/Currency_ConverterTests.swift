//
//  Currency_ConverterTests.swift
//  Currency_ConverterTests
//
//  Created by HƯNG TRẦN on 15/1/25.
//

import XCTest
@testable import Currency_Converter

final class Currency_ConverterTests: XCTestCase {
    var viewModel: CurrencyViewModel!
    
    override func setUp() async throws {
        await MainActor.run {
            viewModel = CurrencyViewModel()
        }
    }
    
    func testInvalidInput() async throws {
        await MainActor.run {
            // Test nhập sai định dạng số
            viewModel.amount = "abc"
        }
        await viewModel.convertCurrency()
        
        await MainActor.run {
            XCTAssertNotNil(viewModel.errorMessage)
            
            // Test nhập số âm
            viewModel.amount = "-100"
        }
        await viewModel.convertCurrency()
        
        await MainActor.run {
            XCTAssertNotNil(viewModel.errorMessage)
        }
    }
    
    func testValidConversion() async throws {
        await MainActor.run {
            viewModel.amount = "100"
            viewModel.selectedFromCurrency = Currency.supportedCurrencies[0] // USD
            viewModel.selectedToCurrency = Currency.supportedCurrencies[1] // EUR
        }
        
        await viewModel.convertCurrency()
        
        await MainActor.run {
            XCTAssertNil(viewModel.errorMessage)
            XCTAssertFalse(viewModel.convertedAmount.isEmpty)
        }
    }
}
