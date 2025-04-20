//
//  NoTeamFeature.swift
//  FutsalGG
//
//  Created by 김태훈 on 4/20/25.
//

//import Foundation
//import ComposableArchitecture
//
//@Reducer
//struct NoTeamFeature {
//    struct State: Equatable {
//        var path = StackState<Path.State>()
//    }
//    
//    enum Action {
//        case path(StackAction<Path.State, Path.Action>)
//        case makeTeam
//        case findTeam
//    }
//    
//    @Reducer
//    struct Path {
//        enum State: Equatable {
//            case makeTeam(TeamFeature.State)
//            case findTeam(TeamFeature.State)
//        }
//        
//        enum Action {
//            case makeTeam(TeamFeature.Action)
//            case findTeam(TeamFeature.Action)
//        }
//        
//        var body: some ReducerOf<Self> {
//            Scope(state: /State.makeTeam, action: /Action.makeTeam) {
//                TeamFeature()
//            }
//            Scope(state: /State.findTeam, action: /Action.findTeam) {
//                TeamFeature()
//            }
//        }
//    }
//    
//    var body: some ReducerOf<Self> {
//        Reduce { state, action in
//            switch action {
//            case .makeTeam:
//                state.path.append(.makeTeam(TeamFeature.State()))
//                return .none
//                
//            case .findTeam:
//                state.path.append(.findTeam(TeamFeature.State()))
//                return .none
//                
//            case .path:
//                return .none
//            }
//        }
//        .forEach(\.path, action: /Action.path) {
//            Path()
//        }
//    }
//}
