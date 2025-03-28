//
//  TeamSearchResponse.swift
//  FutsalGG
//
//  Created by 김태훈 on 3/28/25.
//

import Foundation

struct TeamSearchResponse {
    let teams: [TeamElement]
}

struct TeamElement {
    let id: String
    let name: String
    let createdTime: Date
}
