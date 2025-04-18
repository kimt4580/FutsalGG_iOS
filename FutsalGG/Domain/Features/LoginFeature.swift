//
//  LoginFeature.swift
//  FutsalGG
//
//  Created by 김태훈 on 4/17/25.
//

import Foundation
import ComposableArchitecture

struct LoginFeature: Reducer {
    struct State: Equatable {
        var signUpState = SignUpFeature.State()
        // ... other login states
    }
    
    @CasePathable
    enum Action {
        case signUp(SignUpFeature.Action)
        // ... other login actions
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.signUpState, action: \.signUp) {
            SignUpFeature()
        }
    }
}
