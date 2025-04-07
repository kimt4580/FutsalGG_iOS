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
    case attendMatchMember(_ matchID: String, _ teamMemberIDs: [String])
    case deleteMatchMember(_ matchID: String, _ teamMemberIDs: [String])
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
        case .attendMatchMember:
            return "/match-participants"
        case .deleteMatchMember:
            return "/match-participants"
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
        case .attendMatchMember:
            return .post
        case .deleteMatchMember:
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
        case .makeMatch(let request):
            return .requestJSONEncodable(request)
        case .attendMatchMember(let matchID, let teamMemberIDs):
            var parameters: [String: Any] = ["matchId": matchID, "teamMemberIds": teamMemberIDs]
            return .requestParameters(
                parameters: parameters,
                encoding: JSONEncoding.default
            )
        case .deleteMatchMember(let matchID, let teamMemberIDs):
            var parameters: [String: Any] = ["matchId": matchID, "teamMemberIds": teamMemberIDs]
            return .requestParameters(
                parameters: parameters,
                encoding: JSONEncoding.default
            )
        }
    }
}
