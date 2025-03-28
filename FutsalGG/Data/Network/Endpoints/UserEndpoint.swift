//
//  UserEndpoint.swift
//  FutsalGG
//
//  Created by 김태훈 on 3/26/25.
//

import Foundation
import Moya

enum UserEndpoint {
    case signUp(_ signUpRequest: SignUpRequestDTO)
    case checkNickname(_ nickname: String)
    case getUserLogoUploadURL
    case uploadUserProfileImage(_ uri: String)
}

extension UserEndpoint: APIEndpoint {
    var requiresAuth: Bool {
        true
    }
    
    var path: String {
        switch self {
        case .signUp:
            return "/users"
        case .checkNickname:
            return "/users/check-nickname"
        case .getUserLogoUploadURL:
            return "/users/profile-presigned-url"
        case .uploadUserProfileImage:
            return "/users/profile"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signUp:
            return .patch
        case .checkNickname:
            return .get
        case .getUserLogoUploadURL:
            return .get
        case .uploadUserProfileImage:
            return .patch
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .signUp(let request):
            return .requestJSONEncodable(request)
        case .checkNickname(let nickname):
            return .requestParameters(
                parameters: ["nickname" : nickname],
                encoding: URLEncoding.queryString
            )
        case .getUserLogoUploadURL:
            return .requestPlain
        case .uploadUserProfileImage(let uri):
            return .requestJSONEncodable(uri)
        }
    }
}
