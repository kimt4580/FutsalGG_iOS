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
    case getMyInfo
    case alertSetting(notification: Bool)
    case changeMyInfo(name: String, squadNumber: Int?)
    case signOut
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
        case .getMyInfo:
            return "/users/me"
        case .alertSetting:
            return "/users/me/notification"
        case .changeMyInfo:
            return "/users/me"
        case .signOut:
            return "/users/me"
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
        case .getMyInfo:
            return .get
        case .alertSetting:
            return .patch
        case .changeMyInfo:
            return .patch
        case .signOut:
            return .delete
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
        case .getMyInfo:
            return .requestPlain
        case .alertSetting(let notification):
            return .requestJSONEncodable(notification)
        case .changeMyInfo(let name, let squadNumber):
            var parameters: [String: Any] = ["name": name]
            if let squadNumber {
                parameters["squadNumber"] = squadNumber
            }
            return .requestParameters(
                parameters: parameters,
                encoding: JSONEncoding.default
            )
        case .signOut:
            return .requestPlain
        }
    }
}
