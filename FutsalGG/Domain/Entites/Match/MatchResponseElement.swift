//
//  MatchResponseElement.swift
//  FutsalGG
//
//  Created by 김태훈 on 4/1/25.
//

import Foundation

struct MatchResponseElement {
    let id: String
    let opponentTeamName: String?
    let description: String?
    let type: MatchType
    let matchDate: String // "yyyy-MM-dd" 형식
    let startTime: String? // "HH:mm" 형식
    let endTime: String? // "HH:mm" 형식
    let location: String
    let voteStatus: MatchVoteStatus
    let status: MatchProgress
    let createdTime: Date
}


enum MatchType: String {
    case squad = "INTRA_SQUAD"
    case team = "INTER_TEAM"
}

enum MatchVoteStatus: String {
    case none = "NONE"
    case registered = "REGISTERED"
    case ended = "ENDED"
}

enum MatchProgress: String {
    case draft = "DRAFT"
    case ongoing = "ONGOING"
    case completed = "COMPLETED"
    case canceled = "CANCELED"
}
