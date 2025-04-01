//
//  MatchResponseDTO.swift
//  FutsalGG
//
//  Created by 김태훈 on 4/1/25.
//

import Foundation

struct MatchResponseDTO: Codable {
    let matches: [MatchResponseElementDTO]
}

extension MatchResponseDTO {
    static func initialize() -> MatchResponseDTO {
        .init(
            matches: []
        )
    }
    
    func toDomain() -> MatchResponse {
        MatchResponse(
            matches: matches.map( { $0.toDomain() } )
        )
    }
}
