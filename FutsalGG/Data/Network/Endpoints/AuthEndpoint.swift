//
//  AuthEndpoint.swift
//  FutsalGG
//
//  Created by 김태훈 on 3/25/25.
//

import Foundation
import Moya

enum AuthEndpoint {
    case login(LoginRequestDTO)
    case refresh
}

extension AuthEndpoint: APIEndpoint {
    var path: String {
        switch self {
        case .login:
            return "/auth/login"
        case .refresh:
            return "/auth/refresh"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        case .refresh:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .login(let request):
            return .requestJSONEncodable(request)
        case .refresh:
            return .requestPlain
        }
    }
    
    var requiresAuth: Bool { false }
    
    var customHeaders: [String: String]? {
        switch self {
        case .refresh:
            if let refreshToken = TokenManager.shared.refreshToken {
                return ["Authorization": "Bearer \(refreshToken)"]
            }
            return nil
        default:
            return nil
        }
    }
}
