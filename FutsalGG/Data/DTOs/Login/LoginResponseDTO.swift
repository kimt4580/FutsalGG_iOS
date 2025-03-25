//
//  LoginResponseDTO.swift
//  FutsalGG
//
//  Created by 김태훈 on 3/25/25.
//

import Foundation

struct LoginResponseDTO: Codable {
    let accessToken: String
    let refreshToken: String
    let isNew: Bool
}

extension LoginResponseDTO {
    static func initialize() -> LoginResponseDTO {
        .init(accessToken: "", refreshToken: "", isNew: false)
    }
    
    func toDomain() -> LoginResponse {
        LoginResponse(
            accessToken: accessToken,
            refreshToken: refreshToken,
            isNew: isNew
        )
    }
}
