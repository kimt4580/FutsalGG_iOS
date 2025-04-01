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
    let matchType: TeamMatchPreferenceDTO
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

extension TeamMakeRequestDTO {
    static func initialize() -> TeamMakeRequestDTO {
        return TeamMakeRequestDTO(
            name: "",
            introduction: "",
            rule: "",
            matchType: .all,
            accessLevel: .member,
            dues: 0
        )
    }
    
    func toDomain() -> TeamMakeRequest {
        TeamMakeRequest(
            name: name,
            introduction: introduction,
            rule: rule,
            matchType: matchType.toDomain(),
            accessLevel: accessLevel.toDomain(),
            dues: dues
        )
    }
}

enum AccessLevelDTO: String, Codable {
    case owner = "OWNER"
    case leader = "TEAM_LEADER"
    case deputyLeader = "TEAM_DEPUTY_LEADER"
    case secretary = "TEAM_SECRETARY"
    case member = "TEAM_MEMBER"
}

extension AccessLevelDTO {
    static func initialize() -> AccessLevelDTO {
        .member
    }
    
    func toDomain() -> AccessLevel {
        switch self {
        case .owner:
            return .owner
        case .leader:
            return .leader
        case .deputyLeader:
            return .deputyLeader
        case .secretary:
            return .secretary
        case .member:
            return .member
        }
    }
}

enum TeamMatchPreferenceDTO: String, Codable {
    case all = "ALL"
}

extension TeamMatchPreferenceDTO {
    static func initialize() -> TeamMatchPreferenceDTO {
        .all
    }
    
    func toDomain() -> TeamMatchPreference {
        switch self {
        case .all:
            return .all
        }
    }
}
