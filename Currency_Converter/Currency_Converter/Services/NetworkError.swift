//
//  NetworkError.swift
//  Currency_Converter
//
//  Created by HƯNG TRẦN on 15/1/25.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    // Network related cases
    case invalidURL
    case invalidResponse
    case networkError(Error)
    case decodingError
    
    // Currency related cases
    case negativeAmount
    case zeroAmount
    case invalidFormat
    case sameCurrency
    case unavailableRate
    
    var message: String {
        switch self {
        // Network related messages
        case .invalidURL:
            return "URL không hợp lệ"
        case .invalidResponse:
            return "Phản hồi từ server không hợp lệ"
        case .networkError(let error):
            return "Lỗi kết nối: \(error.localizedDescription)"
        case .decodingError:
            return "Lỗi xử lý dữ liệu"
            
        // Currency related messages
        case .negativeAmount:
            return "Vui lòng nhập số dương lớn hơn 0"
        case .zeroAmount:
            return "Số tiền không thể bằng 0"
        case .invalidFormat:
            return "Định dạng đầu vào không hợp lệ. Vui lòng chỉ nhập số"
        case .sameCurrency:
            return "Vui lòng chọn hai loại tiền khác nhau"
        case .unavailableRate:
            return "Tỷ giá không khả dụng cho cặp tiền tệ này"
        }
    }
}
