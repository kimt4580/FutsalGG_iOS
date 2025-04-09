//
//  MatchScoreResponseDTO.swift
//  FutsalGG
//
//  Created by 김태훈 on 4/8/25.
//

import Foundation

struct MatchScoreResponseDTO: Codable {
    let id: String
    let matchParticipantID: Int
    let roundNumber: Int
    let statType: StatTypeDTO
    let assistedMatchStatID: String?
    let historyTime: Date
    let createdTime: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case matchParticipantID = "matchParticipantId"
        case roundNumber = "round_number"
        case statType
        case assistedMatchStatID = "assistedMatchStatId"
        case historyTime
        case createdTime
    }
}
