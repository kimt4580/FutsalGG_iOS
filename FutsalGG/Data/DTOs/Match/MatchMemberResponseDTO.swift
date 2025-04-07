//
//  MatchMemberResponseDTO.swift
//  FutsalGG
//
//  Created by 김태훈 on 4/7/25.
//

import Foundation

struct MatchMemberResponseDTO: Codable {
    let id: String
    let matchID: String
    let teamMemberID: String
    let name: String
    let role: AccessLevelDTO
    let subTeam: SubTeamDTO
    let createdTime: Date
}

enum SubTeamDTO: String, Codable {
    case none = "NONE"
    case a = "A"
    case b = "B"
}
