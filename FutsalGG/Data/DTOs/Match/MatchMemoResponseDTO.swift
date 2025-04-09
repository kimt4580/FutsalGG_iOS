//
//  MatchMemoResponseDTO.swift
//  FutsalGG
//
//  Created by 김태훈 on 4/8/25.
//

import Foundation

struct MatchMemoResponseDTO: Codable {
    let id: String
    let matchID: String
    let description: String?
    let photos: [ImageUploadURLResponseDTO]
    let updatedTime: Date?
    let createdTime: Date?
}
