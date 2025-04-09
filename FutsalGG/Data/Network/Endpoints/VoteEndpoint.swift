//
//  VoteEndpoint.swift
//  FutsalGG
//
//  Created by 김태훈 on 4/9/25.
//

import Foundation
import Moya

enum VoteEndpoint {
    case voteMOMMember(matchID: String, targetMatchParticipantID: String)
    case attendMatch(matchID: String, participationChoice: String)
}

extension VoteEndpoint: APIEndpoint {
    var requiresAuth: Bool {
        true
    }
    
    var path: String {
        switch self {
        case .voteMOMMember:
            return "/votes/mom"
        case .attendMatch:
            return "/votes/participation"
            
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .voteMOMMember:
            return .post
        case .attendMatch:
            return .put
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .voteMOMMember(let matchID, let targetMatchParticipantID):
            let parameters: [String: Any] = [
                "matchId": matchID,
                "targetMatchParticipantId": targetMatchParticipantID
            ]
            return .requestParameters(
                parameters: parameters,
                encoding: JSONEncoding.default
            )
        case .attendMatch(let matchID, let participationChoice):
            let parameters: [String: Any] = [
                "matchId": matchID,
                "participationChoice": participationChoice
            ]
            return .requestParameters(
                parameters: parameters,
                encoding: JSONEncoding.default
            )
            
        }
    }
}
