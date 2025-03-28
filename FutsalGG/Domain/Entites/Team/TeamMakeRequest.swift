//
//  TeamMakeRequest.swift
//  FutsalGG
//
//  Created by 김태훈 on 3/28/25.
//

import Foundation

struct TeamMakeRequest {
    let name: String
    let introduction: String
    let rule: String
    let matchType: MatchType
    let accessLevel: AccessLevel
    let dues: Int
}

enum AccessLevel: String {
    case owner = "OWNER"
    case leader = "TEAM_LEADER"
    case deputyLeader = "TEAM_DEPUTY_LEADER"
    case secretary = "TEAM_SECRETARY"
    case member = "TEAM_MEMBER"
}

enum MatchType: String {
    case all = "ALL"
}
