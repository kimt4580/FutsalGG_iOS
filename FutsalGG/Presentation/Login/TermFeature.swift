//
//  TermFeature.swift
//  FutsalGG
//
//  Created by 김태훈 on 4/17/25.
//

import Foundation
import ComposableArchitecture

struct TermFeature: Reducer {
    struct State: Equatable {
        var isServiceTermChecked: Bool = false
        var isPrivacyTermChecked: Bool = false
        var signUpState = SignUpFeature.State()
        
        var isAllChecked: Bool {
            isServiceTermChecked && isPrivacyTermChecked
        }
    }
    
    enum Action {
        case toggleServiceTerm
        case togglePrivacyTerm
        case toggleAllTerms
        case proceedToSignUp
        case signUp(SignUpFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .toggleServiceTerm:
                state.isServiceTermChecked.toggle()
                return .none
                
            case .togglePrivacyTerm:
                state.isPrivacyTermChecked.toggle()
                return .none
                
            case .toggleAllTerms:
                let newValue = !state.isAllChecked
                state.isServiceTermChecked = newValue
                state.isPrivacyTermChecked = newValue
                return .none
                
            case .proceedToSignUp:
                return .none
                
            case .signUp:
                return .none
            }
        }
        
        Scope(state: \.signUpState, action: /Action.signUp) {
            SignUpFeature()
        }
    }
}
