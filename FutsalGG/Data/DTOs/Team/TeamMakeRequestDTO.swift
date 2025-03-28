//
//  TeamMakeRequestDTO.swift
//  FutsalGG
//
//  Created by 김태훈 on 3/28/25.
//

import Foundation

struct TeamMakeRequestDTO: Codable {
    let name: String
    let introduction: String
    let rule: String
    let matchType: MatchTypeDTO
    let accessLevel: AccessLevelDTO
    let dues: Int
    
    enum CodingKeys: String, CodingKey {
        case name
        case introduction
        case rule
        case matchType
        case accessLevel = "access"
        case dues
    }
}

enum AccessLevelDTO: String, Codable {
    case owner = "OWNER"
    case leader = "TEAM_LEADER"
    case deputyLeader = "TEAM_DEPUTY_LEADER"
    case secretary = "TEAM_SECRETARY"
    case member = "TEAM_MEMBER"
}

enum MatchTypeDTO: String, Codable {
    case all = "ALL"
}
