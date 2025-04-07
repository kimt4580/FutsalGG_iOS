//
//  TeamMemberDTO.swift
//  FutsalGG
//
//  Created by 김태훈 on 4/7/25.
//

import Foundation

struct TeamMemberDTO: Codable {
    let name: String
    let birthDate: String
    let createdTime: String
    let team: TeamInfo
    let match: MatchInfo
    let partener: String?
    
    struct TeamInfo: Codable {
        let id: String
        let name: String
        let role: String
    }
    
    struct MatchInfo: Codable {
        let total: Int
        let history: [MatchHistory]
        
        struct MatchHistory: Codable {
            let id: String
            let result: String
        }
    }
}
