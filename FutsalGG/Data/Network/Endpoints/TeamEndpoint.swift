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
    case getTeamLogoUploadURL(teamID: String)
    case uploadTeamLogoImageWithFile(url: String, file: Data)
    case uploadTeamLogo(teamID: String, uri: String)
    case searchTeamName(teamName: String)
    case joinTeam(teamID: String)
    case getMain
    case getTeamDelegates(_ name: String, _ role: String = "TEAM-MEMBER")
    case getMyTeamMemberProfile
    case getTeamMemberProfile(_ id: String)
    case getMyTeam
    case getTeamMember(teamID: String)
    case getTeamRecord(teamID: String)
    case acceptTeamJoinRequest(memberID: String)
    case declineTeamJoinRequest(memberID: String)
    case changeMemberRole(memberID: String, _ role: RoleDTO)
    case changeMemberStatus(memberID: String, _ status: MemberStatusDTO)
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
        case .getTeamLogoUploadURL(let teamID):
            return "/teams/\(teamID)/logo-presigned-url"
        case .uploadTeamLogoImageWithFile(let url, _):
            return url
        case .uploadTeamLogo(let teamID, _):
            return "/teams/\(teamID)/logo"
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
        case .changeMemberRole(let memberID, _):
            return "/team-members/\(memberID)/role"
        case .changeMemberStatus(let memberID, _):
            return "/team-members/\(memberID)/status"
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
        case .uploadTeamLogoImageWithFile:
            return .put
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
        case .changeMemberRole:
            return .patch
        case .changeMemberStatus:
            return .patch
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .makeTeam(let request):
            return .requestJSONEncodable(request)
        case .checkTeamName(let teamName):
            let parameters: [String: Any] = [
                "nickname": teamName
            ]
            return .requestParameters(
                parameters: parameters,
                encoding: URLEncoding.queryString
            )
        case .getTeamLogoUploadURL:
            return .requestPlain
        case .uploadTeamLogoImageWithFile(_, let file):
            return .requestData(file)
        case .uploadTeamLogo(_, let uri):
            let parameters: [String: Any] = [
                "uri": uri
            ]
            return .requestParameters(
                parameters: parameters,
                encoding: JSONEncoding.default
            )
        case .searchTeamName(let teamName):
            let parameters: [String: Any] = [
                "name": teamName
            ]
            return .requestParameters(
                parameters: parameters,
                encoding: URLEncoding.queryString
            )
        case .joinTeam(let teamID):
            let parameters: [String: Any] = [
                "team-id": teamID
            ]
            return .requestParameters(
                parameters: parameters,
                encoding: URLEncoding.queryString
            )
        case .getMain:
            return .requestPlain
        case .getTeamDelegates(let name, let role):
            let parameters: [String: Any] = [
                "name": name,
                "role": role
            ]
            return .requestParameters(
                parameters: parameters,
                encoding: URLEncoding.queryString
            )
        case .getMyTeamMemberProfile:
            return .requestPlain
        case .getTeamMemberProfile(let teamID):
            let parameters: [String: Any] = [
                "team-id": teamID
            ]
            
            return .requestParameters(
                parameters: parameters,
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
        case .changeMemberRole(_, let role):
            return .requestJSONEncodable(role)
        case .changeMemberStatus(_, let status):
            return .requestJSONEncodable(status)
        }
    }
}
