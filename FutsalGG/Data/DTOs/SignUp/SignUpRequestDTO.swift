//
//  SignUpRequest.swift
//  FutsalGG
//
//  Created by 김태훈 on 3/26/25.
//

import Foundation

struct SignUpRequestDTO: Codable {
    let nickname: String
    let birthDate: String // "yyyy-MM-dd"
    let gender: Gender
    let agreement: Bool
    let notification: Bool
}

extension SignUpRequestDTO {
    static func initialize() -> SignUpRequestDTO {
        .init(
            nickname: "",
            birthDate: "",
            gender: .male,
            agreement: false,
            notification: false
        )
    }
    
    func toDomain() -> SignUpRequest {
        SignUpRequest(
            nickname: nickname,
            birthDate: birthDate,
            gender: gender,
            agreement: agreement,
            notification: notification
        )
    }
}

enum Gender: String, Codable {
    case male = "MALE"
    case female = "FEMALE"
}
