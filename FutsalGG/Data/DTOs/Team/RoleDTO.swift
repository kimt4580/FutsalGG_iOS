//
//  RoleDTO.swift
//  FutsalGG
//
//  Created by 김태훈 on 4/7/25.
//

import Foundation

enum RoleDTO: String, Codable {
    case leader = "TEAM_LEADER"
    case deputyLeader = "TEAM_DEPUTY_LEADER"
    case secretary = "TEAM_SECRETARY"
    case member = "TEAM_MEMBER"
}
