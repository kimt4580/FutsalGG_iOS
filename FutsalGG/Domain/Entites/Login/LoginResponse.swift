//
//  LoginResult.swift
//  FutsalGG
//
//  Created by 김태훈 on 3/25/25.
//

import Foundation

struct LoginResponse {
    let accessToken: String
    let refreshToken: String
    let isNew: Bool
}
