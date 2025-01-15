//
//  Currency_ConverterUITests.swift
//  Currency_ConverterUITests
//
//  Created by HƯNG TRẦN on 15/1/25.
//

import XCTest

final class Currency_ConverterUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launch()
    }
    
    func testBasicConversion() {
        // Test nhập liệu và chuyển đổi
        let amountTextField = app.textFields["Số tiền"]
        amountTextField.tap()
        amountTextField.typeText("100")
        
        app.buttons["Chuyển đổi"].tap()
        
        // Kiểm tra có hiện kết quả
        XCTAssertTrue(app.staticTexts.element(matching: .any, identifier: "Kết quả").exists)
    }
}
