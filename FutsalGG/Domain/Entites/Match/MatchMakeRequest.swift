//
//  MatchMakeRequest.swift
//  FutsalGG
//
//  Created by 김태훈 on 4/1/25.
//

import Foundation

struct MatchMakeRequest {
    let matchDate: String // "yyyy-MM-dd"
    let type: MatchType
    let location: String
    let startTime: String? // "HH:mm", null이면 미정
    let endTime: String? // "HH:mm", null이면 미정
    let opponentTeamName: String?
    let subtitleTeamMemberID: String?
    let description: String?
    let isVote: Bool // true : 투표를 생성할 경우, false : 경기 일정을 생성할 경우
}
