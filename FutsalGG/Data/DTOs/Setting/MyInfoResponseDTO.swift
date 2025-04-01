//
//  MyInfoResponseDTO.swift
//  FutsalGG
//
//  Created by 김태훈 on 4/1/25.
//

import Foundation

struct MyInfoResponseDTO: Codable {
    let email: String
    let name: String
    let squadNumber: Int?
    let notification: Bool
    let profileURL: String?
    let createdTime: Date
    
    enum CodingKeys: String, CodingKey {
        case email
        case name
        case squadNumber
        case notification
        case profileURL = "profileUrl"
        case createdTime
    }
}

extension MyInfoResponseDTO {
    static func initialize() -> MyInfoResponseDTO {
        .init(
            email: "",
            name: "",
            squadNumber: nil,
            notification: false,
            profileURL: nil,
            createdTime: Date()
        )
    }
    
    func toDomain() -> MyInfoResponse {
        MyInfoResponse(
            email: email,
            name: name,
            squadNumber: squadNumber,
            notification: notification,
            profileURL: profileURL,
            createdTime: createdTime
        )
    }
}
