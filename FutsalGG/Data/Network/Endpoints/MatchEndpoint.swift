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
    case makeMatch(request: MatchMakeRequestDTO)
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
        case .makeMatch:
            return "matches"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .checkMatches:
            return .get
        case .deleteMatch:
            return .delete
        case .makeMatch:
            return .post
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
        case .makeMatch(let request):
            return .requestJSONEncodable(request)
        }
    }
}
