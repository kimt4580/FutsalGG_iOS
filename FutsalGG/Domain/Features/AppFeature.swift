////
////  AppFeature.swift
////  FutsalGG
////
////  Created by 김태훈 on 4/20/25.
////
//
//import Foundation
//import ComposableArchitecture
//
//@Reducer
//struct AppFeature {
//    @ObservableState
//    struct State: Equatable {
//        var path = StackState<Path.State>()
//        @CasePathable
//        enum Destination: Equatable {
//            case splash
//            case login(LoginFeature.State)
//            case main(MainFeature.State)
//        }
//        var destination: Destination = .splash
//    }
//    
//    enum Action {
//        case path(StackAction<Path.State, Path.Action>)
//        @CasePathable
//        enum Destination {
//            case login(LoginFeature.Action)
//            case main(MainFeature.Action)
//        }
//        case destination(Destination)
//    }
//    
//    var body: some ReducerOf<Self> {
//        Reduce { state, action in
//            switch action {
//            case .destination(.login(let loginAction)):
//                // 예: 로그인 성공 시 상태 전환
//                // if loginAction == .success { state.destination = .main(MainFeature.State()) }
//                return .none
//            case .destination(.main(let mainAction)):
//                return .none
//            default:
//                return .none
//            }
//        }
//        .forEach(\.path, action: /Action.path) {
//            Path()
//        }
//        .ifCaseLet(/State.Destination.login, action: /Action.Destination.login) {
//            LoginFeature()
//        }
//        .ifCaseLet(/State.Destination.main, action: /Action.Destination.main) {
//            MainFeature()
//        }
//    }
//}
//
//extension AppFeature {
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
//}
