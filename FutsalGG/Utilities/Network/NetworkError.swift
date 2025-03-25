//
//  NetworkError.swift
//  FutsalGG
//
//  Created by 김태훈 on 3/25/25.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case decodingError(Error)
    case unauthorized
    case serverError(Int)
    case underlying(Error)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .unauthorized:
            return "Unauthorized access"
        case .serverError(let code):
            return "Server error with status code: \(code)"
        case .underlying(let error):
            return error.localizedDescription
        case .unknown:
            return "Unknown error occurred"
        }
    }
}
