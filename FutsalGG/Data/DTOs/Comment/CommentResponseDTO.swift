//
//  CommentResponseDTO.swift
//  FutsalGG
//
//  Created by 김태훈 on 4/9/25.
//

import Foundation

struct CommentResponseDTO: Codable {
    let id: String
    let matchID: String
    let teamMemberID: String
    let name: String
    let profileURL: String?
    let text: String
    let isMine: Bool
    let createdTime: Date
}
