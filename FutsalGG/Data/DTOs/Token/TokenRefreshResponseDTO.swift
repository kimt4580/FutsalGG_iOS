//
//  TokenRefreshResponseDTO.swift
//  FutsalGG
//
//  Created by 김태훈 on 3/25/25.
//

import Foundation

struct TokenRefreshResponseDTO: Codable {
    let accessToken: String
    let refreshToken: String
}

extension TokenRefreshResponseDTO {
    static func initialize() -> TokenRefreshResponseDTO {
        .init(accessToken: "", refreshToken: "")
    }
    
    func toDomain() -> TokenRefreshResponse {
        TokenRefreshResponse(
            accessToken: accessToken,
            refreshToken: refreshToken
        )
    }
}
