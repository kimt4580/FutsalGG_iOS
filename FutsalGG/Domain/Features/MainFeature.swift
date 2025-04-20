////
////  MainFeature.swift
////  FutsalGG
////
////  Created by 김태훈 on 4/20/25.
////
//
//import Foundation
//import ComposableArchitecture
//
//@Reducer
//struct MainFeature {
//    @ObservableState
//    struct State: Equatable {
//        var hasTeam: Bool = false
//        var path = StackState<Path.State>()
//    }
//    
//    enum Action {
//        case noTeam(NoTeamFeature.Action)
//        case path(StackAction<Path.State, Path.Action>)
//    }
//    
//    @Dependency(\.dismiss) var dismiss
//    
//    var body: some ReducerOf<Self> {
//        Reduce { state, action in
//            switch action {
//            case .path:
//                return .none
//            case .noTeam:
//                return .none
//            }
//        }
//        .forEach(\.path, action: \.path) {
//            Path()
//        }
//    }
//}
//
//extension MainFeature {
//    @Reducer
//    struct Path {
//        enum State: Equatable {
//            case noTeam(NoTeamFeature.State)
//            case makeTeam(TeamFeature.State)
//            case findTeam(TeamFeature.State)
//        }
//        
//        enum Action {
//            case noTeam(NoTeamFeature.Action)
//            case makeTeam(TeamFeature.Action)
//            case findTeam(TeamFeature.Action)
//        }
//        
//        var body: some ReducerOf<Self> {
//            Scope(state: \.noTeam, action: \.noTeam) {
//                NoTeamFeature()
//            }
//            Scope(state: \.makeTeam, action: \.makeTeam) {
//                TeamFeature()
//            }
//            Scope(state: \.findTeam, action: \.findTeam) {
//                TeamFeature()
//            }
//        }
//    }
//}
