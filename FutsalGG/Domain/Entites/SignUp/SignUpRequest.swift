//
//  SignUpRequest.swift
//  FutsalGG
//
//  Created by 김태훈 on 3/26/25.
//

import Foundation

struct SignUpRequest {
    let nickname: String
    let birthDate: String // "yyyy-MM-dd"
    let gender: Gender
    let agreement: Bool
    let notification: Bool
}
