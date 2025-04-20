//
//  CreateMatchFeature.swift
//  FutsalGG
//
//  Created by 김태훈 on 4/20/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct CreateMatchFeature {
    struct State: Equatable {
        @BindingState var date: String = ""
        @BindingState var location: String = ""
        @BindingState var startTime: String = ""
        @BindingState var endTime: String = ""
        @BindingState var showCalendar: Bool = false
        @BindingState var isStartTimeExpanded: Bool = false
        @BindingState var isEndTimeExpanded: Bool = false
        var dateError: String? = nil
        var locationError: String? = nil
        var showLoading: Bool = false
        var createSuccess: Bool = false
        
        var isFormValid: Bool {
            !date.isEmpty &&
            dateError == nil &&
            !location.isEmpty &&
            locationError == nil
        }
    }
    
    private func formatDate(_ input: String) -> String {
        let filtered = input.filter { $0.isNumber }
        var formatted = ""
        
        let yyyy = String(filtered.prefix(4))
        if !yyyy.isEmpty {
            formatted += yyyy
            if filtered.count >= 4 {
                formatted += "-"
                let mm = String(filtered.dropFirst(4).prefix(2))
                if !mm.isEmpty {
                    formatted += mm
                    if filtered.count >= 6 {
                        formatted += "-"
                        let dd = String(filtered.dropFirst(6).prefix(2))
                        if !dd.isEmpty {
                            formatted += dd
                        }
                    }
                }
            }
        }
        
        return formatted
    }
    
    private func isValidDate(_ dateString: String) -> String? {
        // 날짜 형식이 완성되지 않았으면 에러 메시지 반환
        guard dateString.count == 10 else {
            return "YYYY-MM-DD 형식으로 입력해주세요."
        }
        
        let components = dateString.split(separator: "-")
        guard components.count == 3,
              let year = Int(components[0]),
              let month = Int(components[1]),
              let day = Int(components[2]) else {
            return "YYYY-MM-DD 형식으로 입력해주세요."
        }
        
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        
        guard let date = Calendar.current.date(from: dateComponents) else {
            return "올바른 날짜를 입력해주세요."
        }
        
        let now = Calendar.current.startOfDay(for: Date())
        let selectedDate = Calendar.current.startOfDay(for: date)
        
        guard selectedDate >= now else {
            return "과거 날짜는 선택할 수 없습니다."
        }
        
        return nil
    }
    
    private func isValidLocation(_ location: String) -> String? {
        return location.count > 15 ? "15자 이내로 입력해주세요." : nil
    }
    
    @CasePathable
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case setDate(_ date: String)
        case setLocation(_ location: String)
        case setStartTime(_ time: String)
        case setEndTime(_ time: String)
        case toggleStartTimeExpanded
        case toggleEndTimeExpanded
        case showCalendar
        case createButtonTapped
        case showLoading
        case hideLoading
        case createSuccess
        case confirmCreateSuccess
        case reset
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case let .setDate(date):
                let formatted = formatDate(date)
                state.date = formatted
                state.dateError = isValidDate(formatted)
                return .none
                
            case let .setLocation(location):
                state.location = location
                state.locationError = isValidLocation(location)
                return .none
                
            case let .setStartTime(time):
                state.startTime = time
                return .none
                
            case let .setEndTime(time):
                state.endTime = time
                return .none
                
            case .toggleStartTimeExpanded:
                state.isStartTimeExpanded.toggle()
                return .none
                
            case .toggleEndTimeExpanded:
                state.isEndTimeExpanded.toggle()
                return .none
                
            case .showCalendar:
                state.showCalendar.toggle()
                return .none
                
            case .createButtonTapped:
                return .send(.showLoading)
                
            case .showLoading:
                state.showLoading = true
                return .none
                
            case .hideLoading:
                state.showLoading = false
                return .none
                
            case .createSuccess:
                state.createSuccess = true
                return .none
                
            case .confirmCreateSuccess:
                state.createSuccess = false
                return .none
                
            case .reset:
                state = .init()
                return .none
            }
        }
    }
}
