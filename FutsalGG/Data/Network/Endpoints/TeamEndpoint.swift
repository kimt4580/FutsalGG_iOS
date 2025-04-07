//
//  TeamEndpoint.swift
//  FutsalGG
//
//  Created by 김태훈 on 3/26/25.
//

import Foundation
import Moya

enum TeamEndpoint {
    case makeTeam(_ teamMakeRequest: TeamMakeRequestDTO)
    case checkTeamName(_ teamName: String)
    case getTeamLogoUploadURL
    case uploadTeamLogo(_ uri: String)
    case searchTeamName(_ teamName: String)
    case joinTeam(_ teamID: String)
    case getMain
    case getTeamDelegates(_ name: String, _ role: String = "TEAM-MEMBER")
    case getMyTeamMemberProfile
    case getTeamMemberProfile(_ id: String)
    case getMyTeam
    case getTeamMember(_ teamID: String)
    case getTeamRecord(_ teamID: String)
    case acceptTeamJoinRequest(_ memberID: String)
    case declineTeamJoinRequest(_ memberID: String)
    case changeRole(_ memberID: String, _ role: AccessLevelDTO)
}

extension TeamEndpoint: APIEndpoint {
    var requiresAuth: Bool {
        true
    }
    
    var path: String {
        switch self {
        case .makeTeam:
            return "/teams"
        case .checkTeamName:
            return "/teams/check-nickname"
        case .getTeamLogoUploadURL:
            return "/teams/logo-presigned-url"
        case .uploadTeamLogo:
            return "/teams/logo"
        case .searchTeamName:
            return "/teams"
        case .joinTeam:
            return "/team-members"
        case .getMain:
            return "/teams/me"
        case .getTeamDelegates:
            return "/team-members/active"
        case .getMyTeamMemberProfile:
            return "/team-members/me"
        case .getTeamMemberProfile(let id):
            return "/team-members/\(id)"
        case .getMyTeam:
            return "/teams/me"
        case .getTeamMember:
            return "/teams/me"
        case .getTeamRecord(let teamID):
            return "teams/\(teamID)/analysis"
        case .acceptTeamJoinRequest(let memberID):
            return "/team-members/\(memberID)/status/accpeted"
        case .declineTeamJoinRequest(let memberID):
            return "/team-members/\(memberID)/status/decliend"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .makeTeam:
            return .post
        case .checkTeamName:
            return .get
        case .getTeamLogoUploadURL:
            return .get
        case .uploadTeamLogo:
            return .patch
        case .searchTeamName:
            return .get
        case .joinTeam:
            return .post
        case .getMain:
            return .get
        case .getTeamDelegates:
            return .get
        case .getMyTeamMemberProfile:
            return .get
        case .getTeamMemberProfile:
            return .get
        case .getMyTeam:
            return .get
        case .getTeamMember:
            return .get
        case .getTeamRecord:
            return .get
        case .acceptTeamJoinRequest:
            return .patch
        case .declineTeamJoinRequest:
            return .patch
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .makeTeam(let request):
            return .requestJSONEncodable(request)
        case .checkTeamName(let teamName):
            return .requestParameters(
                parameters: ["nickname": teamName],
                encoding: URLEncoding.queryString
            )
        case .getTeamLogoUploadURL:
            return .requestPlain
        case .uploadTeamLogo(let uri):
            return .requestJSONEncodable(uri)
        case .searchTeamName(let teamName):
            return .requestParameters(
                parameters: ["name": teamName],
                encoding: URLEncoding.queryString
            )
        case .joinTeam(let teamID):
            return .requestParameters(
                parameters: ["team_id": teamID],
                encoding: URLEncoding.queryString
            )
        case .getMain:
            return .requestPlain
        case .getTeamDelegates(let name, let role):
            return .requestParameters(
                parameters: ["name": name, "role": role],
                encoding: URLEncoding.queryString
            )
        case .getMyTeamMemberProfile:
            return .requestPlain
        case .getTeamMemberProfile(let teamID):
            return .requestParameters(
                parameters: ["team-id": teamID],
                encoding: URLEncoding.queryString
            )
        case .getTeamMember:
            return .requestPlain
        case .getMyTeam:
            return .requestPlain
        case .getTeamRecord:
            return .requestPlain
        case .acceptTeamJoinRequest:
            return .requestPlain
        case .declineTeamJoinRequest:
            return .requestPlain
        }
    }
}
