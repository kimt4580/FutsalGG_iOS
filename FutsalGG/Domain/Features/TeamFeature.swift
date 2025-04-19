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
        var teamName: String = ""
        var teamDescription: String = "" {
            didSet {
                if teamDescription.count > 20 {
                    teamDescription = String(teamDescription.prefix(20))
                }
            }
        }
        var teamRule: String = ""
        var selectedManagerRange: ManagerRange? = nil
        var teamLogoImage: UIImage? = nil
        
        var selectedGameType: GameType? = nil
        var membershipFee: String = "" {
            didSet {
                if !membershipFee.isEmpty {
                    // Remove non-numeric characters and limit to 3 digits
                    let numericString = membershipFee.filter { $0.isNumber }
                    let trimmed = String(numericString.prefix(3))
                    // Convert to Int to remove leading zeros, then back to String
                    if let value = Int(trimmed) {
                        membershipFee = String(value)
                    } else {
                        membershipFee = ""
                    }
                }
            }
        }
        var showDropdown: DropdownType? = nil
        
        var showTeamNameError: Bool = false
        var teamNameErrorMessage: String = ""
        var isTeamNameValid: Bool = false
        var isDuplicateChecked: Bool = false
        
        var teamNameSuccessMessage: String = ""
        
        var showLoading: Bool = false
        var makeTeamSuccess: Bool = false
        
        enum ManagerRange: String, CaseIterable, Equatable {
            case teamLeader = "팀장만"
            case deputyLeader = "팀장 + 부팀장"
            case secretary = "팀장 + 부팀장 + 총무"
        }
        
        enum GameType: String, CaseIterable, Equatable {
            case internalMatch = "자체전 (내전)"
            case versusMatch = "매치전 (VS)"
            case all = "모두"
        }
        
        enum DropdownType {
            case managerRange
            case gameType
        }
    }
    
    enum Action: Equatable {
        case setTeamName(String)
        case setTeamDescription(String)
        case setTeamRules(String)
        case validateTeamName
        case checkTeamNameDuplicate
        case setManagerRange(State.ManagerRange)
        case setTeamLogoImage(UIImage)
        case makeTeamButtonTapped
        case showLoading
        case hideLoading
        case makeTeamSuccess
        case confirmMakeTeamSuccess
        case makeTeamComplete
        
        case setGameType(State.GameType)
        case setMembershipFee(String)
        case toggleDropdown(State.DropdownType?)
    }
    
    @Dependency(\.continuousClock) var clock
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .setGameType(type):
                state.selectedGameType = type
                state.showDropdown = nil
                return .none
                
            case let .setMembershipFee(fee):
                // Remove non-numeric characters and limit to 3 digits
                let numericString = fee.filter { $0.isNumber }
                let trimmed = String(numericString.prefix(3))
                // Convert to Int to remove leading zeros, then back to String
                if let value = Int(trimmed) {
                    state.membershipFee = String(value)
                } else {
                    state.membershipFee = ""
                }
                return .none
                
            case let .toggleDropdown(type):
                state.showDropdown = type
                return .none
                
            case let .setTeamName(name):
                state.teamName = name
                state.isDuplicateChecked = false  // Reset duplicate check when name changes
                return .none
                
            case let .setTeamDescription(description):
                state.teamDescription = description
                return .none
                
            case let .setTeamRules(rules):
                state.teamRule = rules
                return .none
                
            case .validateTeamName:
                let allowedCharactersRegex = "^[A-Za-z0-9가-힣_-]+$"
                if state.teamName.range(of: allowedCharactersRegex, options: .regularExpression) == nil {
                    state.showTeamNameError = true
                    state.teamNameErrorMessage = "한글, 영어, 숫자, 하이픈(-), 언더바(_)만 사용 가능합니다."
                    state.isTeamNameValid = false
                    return .none
                }
                
                let profanityWords = ["시발", "씨발", "병신", "새끼", "개새끼", "미친놈", "지랄", "좆밥", "니애미", "느금마", "창녀", "매춘부"]
                if profanityWords.contains(where: { state.teamName.localizedCaseInsensitiveContains($0) }) {
                    state.showTeamNameError = true
                    state.teamNameErrorMessage = "비속어는 사용하실 수 없습니다."
                    state.isTeamNameValid = false
                    return .none
                }
                
                let trimmedTeamName = state.teamName.trimmingCharacters(in: .whitespaces)
                if trimmedTeamName.count < 3 {
                    state.showTeamNameError = true
                    state.teamNameErrorMessage = "팀 명은 3글자 이상이어야 합니다."
                    state.isTeamNameValid = false
                    return .none
                }
                
                state.showTeamNameError = false
                state.teamNameErrorMessage = ""
                state.isTeamNameValid = true
                return .none
                
            case let .setManagerRange(range):
                state.selectedManagerRange = range
                state.showDropdown = nil
                return .none
                
            case let .setTeamLogoImage(image):
                state.teamLogoImage = image
                return .none
                
            case .makeTeamButtonTapped:
                state.showLoading = true
                return .run { send in
                    try await clock.sleep(for: .seconds(2))
                    await send(.hideLoading)
                    await send(.makeTeamSuccess)
                }
                
            case .showLoading:
                state.showLoading = true
                return .none
                
            case .hideLoading:
                state.showLoading = false
                return .none
                
            case .makeTeamSuccess:
                state.makeTeamSuccess = true
                return .none
                
            case .confirmMakeTeamSuccess:
                return .send(.makeTeamComplete)
                
            case .checkTeamNameDuplicate:
                // Test implementation
                let isDuplicate = Bool.random()
                if isDuplicate {
                    state.showTeamNameError = true
                    state.teamNameErrorMessage = "이미 존재하는 팀 명입니다."
                    state.isDuplicateChecked = false
                } else {
                    state.showTeamNameError = false
                    state.teamNameErrorMessage = ""
                    state.teamNameSuccessMessage = "사용 가능한 팀 명입니다."
                    state.isDuplicateChecked = true
                }
                return .none
                
            default:
                return .none
            }
        }
    }
}
