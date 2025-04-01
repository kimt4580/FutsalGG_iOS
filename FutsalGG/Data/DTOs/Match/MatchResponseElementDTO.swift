//
//  MatchResponseElementDTO.swift
//  FutsalGG
//
//  Created by 김태훈 on 4/1/25.
//

import Foundation

struct MatchResponseElementDTO: Codable {
    let id: String
    let opponentTeamName: String?
    let description: String?
    let type: MatchTypeDTO
    let matchDate: String // "yyyy-MM-dd" 형식
    let startDate: Date?
    let endDate: Date?
    let location: String
    let voteStatus: MatchVoteStatusDTO
    let status: MatchProgressDTO
    let createdTime: Date
}

extension MatchResponseElementDTO {
    static func initialize() -> MatchResponseElementDTO {
        .init(
            id: "",
            opponentTeamName: nil,
            description: nil,
            type: .squad,
            matchDate: "",
            startDate: nil,
            endDate: nil,
            location: "",
            voteStatus: .none,
            status: .draft,
            createdTime: Date()
        )
    }
    
    func toDomain() -> MatchResponseElement {
        MatchResponseElement(
            id: id,
            opponentTeamName: opponentTeamName,
            description: description,
            type: type.toDomain(),
            matchDate: matchDate,
            startDate: startDate,
            endDate: endDate,
            location: location,
            voteStatus: voteStatus.toDomain(),
            status: status.toDomain(),
            createdTime: createdTime
        )
    }
}

enum MatchTypeDTO: String, Codable {
    case squad = "INTRA_SQUAD"
    case team = "INTER_TEAM"
}

extension MatchTypeDTO {
    func toDomain() -> MatchType {
        switch self {
        case .squad:
            return .squad
        case .team:
            return .team
        }
    }
}

enum MatchVoteStatusDTO: String, Codable {
    case none = "NONE"
    case registered = "REGISTERED"
    case ended = "ENDED"
}

extension MatchVoteStatusDTO {
    func toDomain() -> MatchVoteStatus {
        switch self {
        case .none:
            return .none
        case .registered:
            return .registered
        case .ended:
            return .ended
        }
    }
}

enum MatchProgressDTO: String, Codable {
    case draft = "DRAFT"
    case ongoing = "ONGOING"
    case completed = "COMPLETED"
    case canceled = "CANCELED"
}

extension MatchProgressDTO {
    func toDomain() -> MatchProgress {
        switch self {
        case .draft:
            return .draft
        case .ongoing:
            return .ongoing
        case .completed:
            return .completed
        case .canceled:
            return .canceled
        }
    }
}
