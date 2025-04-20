//
//  TeamFeature.swift
//  FutsalGG
//
//  Created by 김태훈 on 4/19/25.
//

import Foundation
import ComposableArchitecture
import UIKit

struct TeamFeature: Reducer {
    struct State: Equatable {
        @BindingState var makeTeam: MakeTeamFeature.State? = nil
        @BindingState var findTeam: FindTeamFeature.State? = nil
        var showLoading: Bool = false
    }
    
    @CasePathable
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case makeTeam(MakeTeamFeature.Action)
        case findTeam(FindTeamFeature.Action)
        case showLoading(Bool)
        case resetMakeTeam
        case resetFindTeam
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case .resetMakeTeam:
                state.makeTeam = MakeTeamFeature.State()
                return .none
                
            case .resetFindTeam:
                state.findTeam = FindTeamFeature.State()
                return .none
                
            case .makeTeam(.makeTeamButtonTapped), .findTeam(.confirmJoin):
                state.showLoading = true
                return .none
                
            case .makeTeam(.makeTeamSuccess), .findTeam(.joinSuccess):
                state.showLoading = false
                return .none
                
            case let .showLoading(isLoading):
                state.showLoading = isLoading
                return .none
                
            default:
                return .none
            }
        }
        .ifLet(\.makeTeam, action: \.makeTeam) {
            MakeTeamFeature()
        }
        .ifLet(\.findTeam, action: \.findTeam) {
            FindTeamFeature()
        }
    }
}
