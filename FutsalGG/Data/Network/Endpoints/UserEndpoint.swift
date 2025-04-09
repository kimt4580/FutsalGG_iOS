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
    case getUserProfileImageUploadURL
    case uploadUserProfileImage(uri: String)
    case uploadUserProfileImageWithFile(url: String, file: Data)
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
        case .getUserProfileImageUploadURL:
            return "/users/profile-presigned-url"
        case .uploadUserProfileImageWithFile(let url, _):
            return url
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
        case .getUserProfileImageUploadURL:
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
        case .uploadUserProfileImageWithFile:
            return .put
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .signUp(let request):
            return .requestJSONEncodable(request)
        case .checkNickname(let nickname):
            let parameters: [String: Any] = [
                "nickname" : nickname
            ]
            return .requestParameters(
                parameters: parameters,
                encoding: URLEncoding.queryString
            )
        case .getUserProfileImageUploadURL:
            return .requestPlain
        case .uploadUserProfileImageWithFile(_, let file):
            return .requestData(file)
        case .uploadUserProfileImage(let uri):
            let parameters: [String: Any] = [
                "uri": uri
            ]
            return .requestParameters(
                parameters: parameters,
                encoding: JSONEncoding.default
            )
        case .getMyInfo:
            return .requestPlain
        case .alertSetting(let notification):
            return .requestJSONEncodable(notification)
        case .changeMyInfo(let name, let squadNumber):
            var parameters: [String: Any] = [
                "name": name
            ]
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
