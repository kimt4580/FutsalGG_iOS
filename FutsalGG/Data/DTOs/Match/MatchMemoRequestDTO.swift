//
//  MatchMemoRequestDTO.swift
//  FutsalGG
//
//  Created by 김태훈 on 4/8/25.
//

import Foundation

struct MatchMemoRequestDTO: Codable {
    let id: String?
    let matchID: String
    let description: String
    let photoURIs: [String]
    
    enum CodingKeys: String, CodingKey {
        case id
        case matchID = "matchId"
        case description
        case photoURIs = "photoUris"
    }
}
