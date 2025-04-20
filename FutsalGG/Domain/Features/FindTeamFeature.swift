//
//  FindTeamFeature.swift
//  FutsalGG
//
//  Created by 김태훈 on 4/20/25.
//

import Foundation
import ComposableArchitecture

struct FindTeamFeature: Reducer {
    struct State: Equatable {
        var searchTeamName: String = ""
        var selectedTeamID: String? = nil
        var selectedGameType: GameType? = nil
        var teams: [Team] = []
        var showDropdown: DropdownType? = nil
        var showJoinConfirmation: Bool = false
        var showJoinSuccess: Bool = false
        
        enum GameType: String, CaseIterable, Equatable {
            case internalMatch = "자체전 (내전)"
            case versusMatch = "매치전 (VS)"
            case all = "모두"
        }
        
        enum DropdownType {
            case gameType
        }
    }
    
    enum Action: Equatable {
        case setSearchTeamName(String)
        case setGameType(State.GameType)
        case toggleDropdown(State.DropdownType?)
        case selectTeam(String?)
        case searchTeams
        case clearTeams
        case joinButtonTapped
        case confirmJoin
        case cancelJoin
        case joinSuccess
        case confirmJoinSuccess
    }
    
    @Dependency(\.continuousClock) var clock
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .setSearchTeamName(name):
                state.searchTeamName = name
                return .none
                
            case let .setGameType(type):
                state.selectedGameType = type
                state.showDropdown = nil
                return .none
                
            case let .toggleDropdown(type):
                state.showDropdown = type
                return .none
                
            case let .selectTeam(teamId):
                state.selectedTeamID = teamId
                return .none
                
            case .searchTeams:
                state.teams = [
                    Team(id: "1", teamName: "FC Barcelona", teamLeaderName: "메시", teamMemberCount: "11"),
                    Team(id: "2", teamName: "Real Madrid", teamLeaderName: "호날두", teamMemberCount: "11"),
                    Team(id: "3", teamName: "맨체스터 시티", teamLeaderName: "홀란드", teamMemberCount: "11"),
                    Team(id: "4", teamName: "리버풀", teamLeaderName: "살라", teamMemberCount: "11")
                ]
                return .none
                
            case .clearTeams:
                state = State()
                return .none
                
            case .joinButtonTapped:
                state.showJoinConfirmation = true
                return .none
                
            case .confirmJoin:
                state.showJoinConfirmation = false
                return .run { send in
                    try await clock.sleep(for: .seconds(2))
                    await send(.joinSuccess)
                }
                
            case .cancelJoin:
                state.showJoinConfirmation = false
                return .none
                
            case .joinSuccess:
                state.showJoinSuccess = true
                return .none
                
            case .confirmJoinSuccess:
                return .none
            }
        }
    }
}

struct Team: Equatable, Identifiable {
    let id: String
    let teamName: String
    let teamLeaderName: String
    let teamMemberCount: String
}
