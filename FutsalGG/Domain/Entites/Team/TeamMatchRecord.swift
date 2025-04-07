//
//  TeamMatchRecord.swift
//  FutsalGG
//
//  Created by 김태훈 on 4/7/25.
//

import Foundation

struct TeamMatchRecordResponse {
    let id: String
    let match: RecordMatch
    let analysis: Analysis
}

struct RecordMatch {
    let numIntraSqaud: Int
    let numInterTeam: Int
    let lastMatchedTime: Date?
}

struct Ranker {
    let name: String
    let profileURL: String?
    
}

struct AnalysisItem{
    let first: RankerDTO
    let second: RankerDTO
}

struct Analysis {
    let attendance: AnalysisItem
    let winRate: AnalysisItem
    let mom: AnalysisItem
    let goal: AnalysisItem
    let assist: AnalysisItem
}
