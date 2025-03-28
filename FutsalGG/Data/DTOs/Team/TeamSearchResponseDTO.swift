//
//  TeamSearchResponseDTO.swift
//  FutsalGG
//
//  Created by 김태훈 on 3/28/25.
//

import Foundation

struct TeamSearchResponseDTO: Codable {
    let teams: [TeamElementDTO]
}

struct TeamElementDTO: Codable {
    let id: String
    let name: String
    let createdTime: Date
}

extension TeamSearchResponseDTO {
    static func initialize() -> TeamSearchResponseDTO {
        return .init(
            teams: []
        )
    }
    
    func toDomain() -> TeamSearchResponse {
        TeamSearchResponse(
            teams: teams.map { dto in
                TeamElement(
                    id: dto.id,
                    name: dto.name,
                    createdTime: dto.createdTime
                )
            }
        )
    }
}
