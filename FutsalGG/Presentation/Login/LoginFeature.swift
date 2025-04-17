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
        var path = StackState<Path.State>()
        var signUpState = SignUpFeature.State()
        // ... other login states
    }
    
    enum Action {
        case path(StackAction<Path.State, Path.Action>)
        case signUp(SignUpFeature.Action)
        // ... other login actions
    }
    
    struct Path: Reducer {
        enum State: Equatable {
            case signUp(SignUpFeature.State)
            // ... other path states
        }
        
        enum Action {
            case signUp(SignUpFeature.Action)
            // ... other path actions
        }
        
        var body: some ReducerOf<Self> {
            Reduce { state, action in
                switch action {
                case .signUp(.signUpComplete):
                    return .none
                default:
                    return .none
                }
            }
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .path(.element(id, .signUp(.signUpComplete))):
                state.path.removeAll()
                // TODO: Navigate to main view or update authentication state
                return .none
                
            default:
                return .none
            }
        }
        .forEach(\.path, action: /Action.path) {
            Path()
        }
        Scope(state: \.signUpState, action: /Action.signUp) {
            SignUpFeature()
        }
    }
}
