//
//  CommentEndpoint.swift
//  FutsalGG
//
//  Created by 김태훈 on 4/9/25.
//

import Foundation
import Moya

enum CommentEndpoint {
    case getComments(matchID: String)
    case writeComment(matchID: String, text: String)
}

extension CommentEndpoint: APIEndpoint {
    var requiresAuth: Bool {
        true
    }
    
    var path: String {
        switch self {
        case .getComments:
            return "/comments"
        case .writeComment:
        return "/comments"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getComments:
            return .get
        case .writeComment:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getComments(let matchID):
            let parameters: [String: Any] = [
                "matchId": matchID
            ]
            return .requestParameters(
                parameters: parameters,
                encoding: URLEncoding.queryString
            )
        case .writeComment(let matchID, let text):
            let parameters: [String: Any] = [
                "matchId": matchID,
                "text": text
            ]
            return .requestParameters(
                parameters: parameters,
                encoding: JSONEncoding.default
            )
        }
    }
}
