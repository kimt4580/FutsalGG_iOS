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
    case attendMatchMember(matchID: String, _ teamMemberIDs: [String])
    case deleteMatchMember(matchID: String, _ teamMemberIDs: [String])
    case registerMatch(matchID: String, matchMemberIDs: [String], _ subTeam: SubTeamDTO)
    case setMatchRound(matchID: String, _ roundCount: Int)
    case getMatch(matchID: String)
    case getMatchMembers(matchID: String)
    case getMatchStatistics(matchID: String)
    case recordMatchScore(_ request: MatchScoreRequestDTO)
    case deleteMatchScore(matchStatID: String)
    case uploadMatchMemoURL(matchID: String)
    case uploadMatchMemoImageWithFile(url: String, file: Data)
    case uploadMatchMemo(_ request: MatchMemoRequestDTO)
    case getMatchMemo(matchID: String)
    case getMOMMember(matchID: String)
    case getMonthVote(date: String) // "yyyy-MM" 형식
    case endVote(matchID: String)
    case changeMatchStatus(matchID: String)
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
        case .registerMatch:
            return "/match-participants/bulk/sub-team"
        case .setMatchRound(let matchID, _):
            return "/match/\(matchID)/rounds"
        case .getMatch(let matchID):
            return "/match/\(matchID)"
        case .getMatchMembers:
            return "/match-participants"
        case .getMatchStatistics:
            return "/match-stats"
        case .recordMatchScore:
            return "/match-stats"
        case .deleteMatchScore(let matchStatID):
            return "/match-stats/\(matchStatID)"
        case .uploadMatchMemoURL:
            return "/match-notes/presigned-url"
        case .uploadMatchMemoImageWithFile(let url, _):
            return url
        case .uploadMatchMemo:
            return "/match-notes"
        case .getMatchMemo:
            return "/match-notes/one"
        case .getMOMMember:
            return "/match-participants/mom"
        case .getMonthVote:
            return "/matches/vote"
        case .endVote(let matchID):
            return "/matches/\(matchID)/vote-status/ended"
        case .changeMatchStatus(let matchID):
            return "/matches/\(matchID)/status/ongoing"
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
        case .registerMatch:
            return .patch
        case .setMatchRound:
            return .patch
        case .getMatch:
            return .get
        case .getMatchMembers:
            return .get
        case .getMatchStatistics:
            return .get
        case .recordMatchScore:
            return .post
        case .deleteMatchScore:
            return .delete
        case .uploadMatchMemoURL:
            return .get
        case .uploadMatchMemoImageWithFile:
            return .put
        case .uploadMatchMemo:
            return .put
        case .getMatchMemo:
            return .get
        case .getMOMMember:
            return .get
        case .getMonthVote:
            return .get
        case .endVote:
            return .patch
        case .changeMatchStatus:
            return .patch
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .checkMatches(let page, let size):
            let parameters: [String: Any] = [
                "page": page,
                "size": size
            ]
            return .requestParameters(
                parameters: parameters,
                encoding: URLEncoding.queryString
            )
        case .deleteMatch:
            return .requestPlain
        case .makeMatch(let request):
            return .requestJSONEncodable(request)
        case .attendMatchMember(let matchID, let teamMemberIDs):
            let parameters: [String: Any] = [
                "matchId": matchID,
                "teamMemberIds": teamMemberIDs
            ]
            return .requestParameters(
                parameters: parameters,
                encoding: JSONEncoding.default
            )
        case .deleteMatchMember(let matchID, let teamMemberIDs):
            let parameters: [String: Any] = [
                "matchId": matchID,
                "teamMemberIds": teamMemberIDs
            ]
            return .requestParameters(
                parameters: parameters,
                encoding: JSONEncoding.default
            )
        case .registerMatch(let matchID, let matchMemberIDs, let subTeam):
            let parameters: [String: Any] = [
                "matchId": matchID,
                "ids": matchMemberIDs,
                "subTeam": subTeam
            ]
            return .requestParameters(
                parameters: parameters,
                encoding: JSONEncoding.default
            )
        case .setMatchRound(_, let roundCount):
            let parameters: [String: Any] = [
                "roundCount": roundCount
            ]
            return .requestParameters(
                parameters: parameters,
                encoding: JSONEncoding.default
            )
        case .getMatch:
            return .requestPlain
        case .getMatchMembers(let matchID):
            let parameters: [String: Any] = [
                "matchId": matchID
            ]
            return .requestParameters(
                parameters: parameters,
                encoding: URLEncoding.queryString
            )
        case .getMatchStatistics(let matchID):
            let parameters: [String: Any] = [
                "matchId": matchID
            ]
            return .requestParameters(
                parameters: parameters,
                encoding: URLEncoding.queryString
            )
        case .recordMatchScore(let request):
            return .requestJSONEncodable(request)
        case .deleteMatchScore:
            return .requestPlain
        case .uploadMatchMemoURL(let matchID):
            let parameters: [String: Any] = [
                "matchId": matchID
            ]
            return .requestParameters(
                parameters: parameters,
                encoding: URLEncoding.queryString
            )
        case .uploadMatchMemoImageWithFile(_, let file):
            return .requestData(file)
        case .uploadMatchMemo(let request):
            return .requestJSONEncodable(request)
        case .getMatchMemo(let matchID):
            let parameters: [String: Any] = [
                "matchId": matchID
            ]
            return .requestParameters(
                parameters: parameters,
                encoding: JSONEncoding.default
            )
        case .getMOMMember(let matchID):
            let parameters: [String: Any] = [
                "matchId": matchID
            ]
            return .requestParameters(
                parameters: parameters,
                encoding: URLEncoding.queryString
            )
        case .getMonthVote(let date):
            let parameters: [String: Any] = [
                "date": date
            ]
            return .requestParameters(
                parameters: parameters,
                encoding: URLEncoding.queryString
            )
        case .endVote:
            return .requestPlain
        case .changeMatchStatus:
            return .requestPlain
        }
    }
}
