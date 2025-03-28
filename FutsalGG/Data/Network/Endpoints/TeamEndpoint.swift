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
    case checkNickname(_ nickname: String)
    case getTeamLogoUploadURL
    case uploadTeamLogo(_ uri: String)
}

extension TeamEndpoint: APIEndpoint {
    var requiresAuth: Bool {
        true
    }
    
    var path: String {
        switch self {
        case .makeTeam:
            return "/teams"
        case .checkNickname:
            return "/teams/check-nickname"
        case .getTeamLogoUploadURL:
            return "/teams/logo-presigned-url"
        case .uploadTeamLogo:
            return "/teams/logo"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .makeTeam:
            return .post
        case .checkNickname:
            return .get
        case .getTeamLogoUploadURL:
            return .get
        case .uploadTeamLogo:
            return .patch
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .makeTeam(let request):
            return .requestJSONEncodable(request)
        case .checkNickname(let nickname):
            return .requestParameters(parameters: ["nickname" : nickname], encoding: URLEncoding.queryString)
        case .getTeamLogoUploadURL:
            return .requestPlain
        case .uploadTeamLogo(let uri):
            return .requestJSONEncodable(uri)
        }
    }
}


