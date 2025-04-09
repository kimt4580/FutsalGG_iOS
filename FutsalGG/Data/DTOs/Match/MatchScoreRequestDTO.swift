//
//  MatchScoreRequestDTO.swift
//  FutsalGG
//
//  Created by 김태훈 on 4/8/25.
//

import Foundation

struct MatchScoreRequestDTO: Codable {
    let matchParticipantID: String
    let roundNumber: Int
    let statType: StatTypeDTO
    let assistedMatchStatID: String?
    
    enum CodingKeys: String, CodingKey {
        case matchParticipantID = "matchParticipantId"
        case roundNumber
        case statType
        case assistedMatchStatID = "assistedMatchStatId"
    }
}

enum StatTypeDTO: String, Codable {
    case goal = "GOAL"
    case assist = "ASSIST"
}
