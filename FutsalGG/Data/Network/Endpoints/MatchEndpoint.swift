//
//  MatchEndpoint.swift
//  FutsalGG
//
//  Created by 김태훈 on 4/1/25.
//

import Foundation
import Moya

enum MatchEndpoint {
    case checkMatches(page: Int, size: Int)
    case deleteMatch(id: Int)
}

extension MatchEndpoint: APIEndpoint {
    var requiresAuth: Bool {
        true
    }
    
    var path: String {
        switch self {
        case .checkMatches:
            return "/matches"
        case .deleteMatch(let id):
            return "/matches/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .checkMatches:
            return .get
        case .deleteMatch:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .checkMatches(let page, let size):
            return .requestParameters(
                parameters: ["page": page, "size": size],
                encoding: URLEncoding.queryString
            )
        case .deleteMatch:
            return .requestPlain
        }
    }
}


