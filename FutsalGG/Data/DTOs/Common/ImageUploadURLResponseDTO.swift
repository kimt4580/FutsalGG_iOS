//
//  ImageUploadURLResponseDTO.swift
//  FutsalGG
//
//  Created by 김태훈 on 3/26/25.
//

import Foundation

struct ImageUploadURLResponseDTO: Codable {
    let url: String
    let uri: String
}

extension ImageUploadURLResponseDTO {
    static func initialize() -> ImageUploadURLResponseDTO {
        .init(
            url: "",
            uri: ""
        )
    }
    
    func toDomain() -> ImageUploadURLResponse {
        ImageUploadURLResponse(url: url, uri: uri)
    }
}
