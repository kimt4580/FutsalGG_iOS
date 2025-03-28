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
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .makeTeam(let request):
            return .requestJSONEncodable(request)
        case .checkTeamName(let teamName):
            return .requestParameters(
                parameters: ["nickname" : teamName],
                encoding: URLEncoding.queryString
            )
        case .getTeamLogoUploadURL:
            return .requestPlain
        case .uploadTeamLogo(let uri):
            return .requestJSONEncodable(uri)
        case .searchTeamName(let teamName):
            return .requestParameters(
                parameters: ["name" : teamName],
                encoding: URLEncoding.queryString
            )
        case .joinTeam(let teamID):
            return .requestParameters(
                parameters: ["team_id" : teamID],
                encoding: URLEncoding.queryString
            )
        case .getMain:
            return .requestPlain
        }
    }
}


