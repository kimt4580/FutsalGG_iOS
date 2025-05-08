//
//  SignUpFeature.swift
//  FutsalGG
//
//  Created by 김태훈 on 4/17/25.
//

import Foundation
import ComposableArchitecture
import UIKit

struct SignUpFeature: Reducer {
    
    @ObservableState
    struct State: Equatable {
        var nickname: String = ""
        var birthday: String = ""
        var selectedGender: Gender? = nil
        var profileImage: UIImage? = nil
        var isAllowNotification: Bool = false
        
        var showBirthdayError: Bool = false
        var showNicknameError: Bool = false
        var nicknameErrorMessage: String = ""
        var birthdayErrorMessage: String = ""
        var isNicknameValid: Bool = false
        var isDuplicateChecked: Bool = false
        
        var showLoading: Bool = false
        var signUpSuccess: Bool = false
        
        enum Gender: Equatable {
            case male, female
        }
    }
    
    @CasePathable
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case setNickname(String)
        case validateNickname
        case checkNicknameDuplicate
        case setBirthday(String)
        case validateBirthday
        case setGender(State.Gender)
        case setProfileImage(UIImage)
        case setNotificationPermission(Bool)
        case signUpButtonTapped
        case showLoading
        case hideLoading
        case signUpSuccess
        case confirmSignUpSuccess
        case signUpComplete
    }
    
    @Dependency(\.continuousClock) var clock
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .signUpButtonTapped:
                state.showLoading = true
                return .run { send in
                    try await clock.sleep(for: .seconds(2))
                    await send(.hideLoading)
                    await send(.signUpSuccess)
                }
                
            case .showLoading:
                state.showLoading = true
                return .none
                
            case .hideLoading:
                state.showLoading = false
                return .none
                
            case .signUpSuccess:
                state.signUpSuccess = true
                return .none
                
            case .confirmSignUpSuccess:
                return .send(.signUpComplete)
                
            default:
                return .none
            }
        }
    }
}
