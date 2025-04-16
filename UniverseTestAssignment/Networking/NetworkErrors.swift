//
//  NetworkErrors.swift
//  UniverseTestAssignment
//
//  Created by Zakhar Litvinchuk on 16.04.2025.
//

import Foundation

enum NetworkingError: Error {
    case requestError
    case decodingError
    case invalidResponse
    
    var description: String {
        switch self {
        case .requestError:
            "Network request error"
        case .decodingError:
            "Decoding error"
        case .invalidResponse:
            "Invalid response"
        }
    }
}
