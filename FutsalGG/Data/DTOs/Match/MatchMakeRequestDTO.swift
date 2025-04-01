//
//  MatchMakeRequestDTO.swift
//  FutsalGG
//
//  Created by 김태훈 on 4/1/25.
//

import Foundation

struct MatchMakeRequestDTO: Codable {
    let matchDate: String // "yyyy-MM-dd"
    let type: MatchTypeDTO
    let location: String
    let startTime: String? // "HH:mm", null이면 미정
    let endTime: String? // "HH:mm", null이면 미정
    let opponentTeamName: String?
    let subtitleTeamMemberID: String?
    let description: String?
    let isVote: Bool // true : 투표를 생성할 경우, false : 경기 일정을 생성할 경우
    
    enum CodingKeys: String, CodingKey {
        case matchDate
        case type
        case location
        case startTime
        case endTime
        case opponentTeamName
        case subtitleTeamMemberID = "subtitleTeamMemberId"
        case description
        case isVote = "is_vote"
    }
}

extension MatchMakeRequestDTO {
    static func initialize() -> MatchMakeRequestDTO {
        .init(
            matchDate: "",
            type: .squad,
            location: "",
            startTime: nil,
            endTime: nil,
            opponentTeamName: nil,
            subtitleTeamMemberID: nil,
            description: nil,
            isVote: false
        )
    }
    
    func toDomain() -> MatchMakeRequest {
        MatchMakeRequest(
            matchDate: matchDate,
            type: type.toDomain(),
            location: location,
            startTime: startTime,
            endTime: endTime,
            opponentTeamName: opponentTeamName,
            subtitleTeamMemberID: subtitleTeamMemberID,
            description: description,
            isVote: isVote
        )
    }
}
