//
//  MainResponseDTO.swift
//  FutsalGG
//
//  Created by 김태훈 on 3/28/25.
//

import Foundation

struct MainResponseDTO: Codable {
    let id: String
    let teamMemberID: String
    let name: String
    let logoURL: String
    let role: AccessLevelDTO
    let createdTime: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case teamMemberID = "team_member_id"
        case name
        case logoURL = "logo_url"
        case role
        case createdTime
    }
}

extension MainResponseDTO {
    static func initialize() -> MainResponseDTO {
        MainResponseDTO(
            id: "",
            teamMemberID: "",
            name: "",
            logoURL: "",
            role: .initialize(),
            createdTime: Date()
        )
    }
    
    func toDomain() -> MainResponse {
        MainResponse(
            id: id,
            teamMemberID: teamMemberID,
            name: name,
            logoURL: logoURL,
            role: role.toDomain(),
            createdTime: createdTime
        )
    }
}
