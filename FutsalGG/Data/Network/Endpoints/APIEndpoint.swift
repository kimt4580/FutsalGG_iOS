//
//  APIEndpoint.swift
//  FutsalGG
//
//  Created by 김태훈 on 3/25/25.
//

import Foundation
import Moya

protocol APIEndpoint: TargetType {
    var requiresAuth: Bool { get }
    var customHeaders: [String: String]? { get }  // 추가
}

extension APIEndpoint {
    var baseURL: URL {
        #if DEBUG
        return URL(string: AppConstant.shared.DEV_URL)!
        #else
        return URL(string: AppConstant.shared.BASE_URL)!
        #endif
    }
    
    // 기본 헤더 구현
    var headers: [String: String]? {
        var headers = ["Content-Type": "application/json"]
        
        // 커스텀 헤더가 있으면 추가
        if let customHeaders = customHeaders {
            headers.merge(customHeaders) { current, _ in current }
        }
        
        // 인증이 필요하면 Bearer 토큰 추가
        if requiresAuth,
           let token = TokenManager.shared.accessToken {
            headers["Authorization"] = "Bearer \(token)"
        }
        
        return headers
    }
    
    // 기본값 제공
    var customHeaders: [String: String]? {
        nil
    }
    
    var sampleData: Data {
        Data()
    }
}
