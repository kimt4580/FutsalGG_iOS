//
//  LoginRequestDTO.swift
//  FutsalGG
//
//  Created by 김태훈 on 3/24/25.
//

import Foundation

struct LoginRequestDTO: Codable {
    let token: String
    var platform: String = "APPLE"
}

extension LoginRequestDTO {
    static func initialize() -> LoginRequestDTO {
        .init(token: "")
    }
    
    func toDomain() -> LoginRequest {
        LoginRequest(token: token, platform: platform)
    }
}
