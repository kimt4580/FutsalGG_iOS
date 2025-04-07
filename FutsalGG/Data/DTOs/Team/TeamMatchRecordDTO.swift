//
//  TeamMatchRecordResponse.swift
//  FutsalGG
//
//  Created by 김태훈 on 4/7/25.
//

import Foundation

struct TeamMatchRecordDTO: Codable {
    let id: String
    let match: RecordMatchDTO
    let analysis: AnalysisDTO
}

extension TeamMatchRecordDTO {
    static func initialize() -> TeamMatchRecordDTO {
        TeamMatchRecordDTO(
            id: "",
            match: .initialize(),
            analysis: .initialize()
        )
    }
    
    func toDomain() -> TeamMatchRecordResponse {
        TeamMatchRecordResponse(
            id: id,
            match: match.toDomain(),
            analysis: analysis.toDomain()
        )
    }
}

struct RecordMatchDTO: Codable {
    let numIntraSqaud: Int
    let numInterTeam: Int
    let lastMatchedTime: Date?
}

extension RecordMatchDTO {
    static func initialize() -> RecordMatchDTO {
        RecordMatchDTO(
            numIntraSqaud: 0,
            numInterTeam: 0,
            lastMatchedTime: nil
        )
    }
    
    func toDomain() -> RecordMatch {
        RecordMatch(
            numIntraSqaud: numIntraSqaud,
            numInterTeam: numInterTeam,
            lastMatchedTime: lastMatchedTime
        )
    }
}

struct RankerDTO: Codable {
    let name: String
    let profileUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case profileUrl = "profile_url"
    }
}

extension RankerDTO {
    static func initialize() -> RankerDTO {
        RankerDTO(name: "", profileUrl: nil)
    }
}

struct AnalysisItemDTO: Codable {
    let first: RankerDTO
    let second: RankerDTO
}

extension AnalysisItemDTO {
    static func initialize() -> AnalysisItemDTO {
        AnalysisItemDTO(
            first: .initialize(),
            second: .initialize()
        )
    }
    
    func toDomain() -> AnalysisItem {
        AnalysisItem(
            first: first,
            second: second
        )
    }
}

struct AnalysisDTO: Codable {
    let attendance: AnalysisItemDTO
    let winRate: AnalysisItemDTO
    let mom: AnalysisItemDTO
    let goal: AnalysisItemDTO
    let assist: AnalysisItemDTO
}

extension AnalysisDTO {
    static func initialize() -> AnalysisDTO {
        AnalysisDTO(
            attendance: .initialize(),
            winRate: .initialize(),
            mom: .initialize(),
            goal: .initialize(),
            assist: .initialize()
        )
    }
    
    func toDomain() -> Analysis {
        Analysis(
            attendance: attendance.toDomain(),
            winRate: winRate.toDomain(),
            mom: mom.toDomain(),
            goal: goal.toDomain(),
            assist: assist.toDomain()
        )
    }
}
