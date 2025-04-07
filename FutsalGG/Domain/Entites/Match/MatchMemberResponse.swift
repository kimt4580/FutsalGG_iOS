//
//  MatchMemberResponse.swift
//  FutsalGG
//
//  Created by 김태훈 on 4/7/25.
//

import Foundation

struct MatchMemberResponse {
    let id: String
    let matchID: String
    let teamMemberID: String
    let name: String
    let role: AccessLevel
    let subTeam: SubTeam
    let createdTime: Date
}

enum SubTeam: String {
    case none = "NONE"
    case a = "A"
    case b = "B"
}
