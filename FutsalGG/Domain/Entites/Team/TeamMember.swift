//
//  TeamMember.swift
//  FutsalGG
//
//  Created by 김태훈 on 4/7/25.
//

import Foundation

struct TeamMember {
    let name: String
    let birthDate: Date
    let createdTime: Date
    let team: TeamInfo
    let match: MatchInfo
    let partener: String?
    
    struct TeamInfo {
        let id: String
        let name: String
        let role: TeamRole
        
        enum TeamRole: String {
            case leader = "LEADER"
            case member = "MEMBER"
            case unknown = "UNKNOWN"
        }
    }
    
    struct MatchInfo {
        let total: Int
        let history: [MatchHistory]
        
        struct MatchHistory {
            let id: String
            let result: MatchResult
            
            enum MatchResult: String {
                case win = "WIN"
                case lose = "LOSE"
                case draw = "DRAW"
            }
        }
    }
}
