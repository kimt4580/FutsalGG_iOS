//
//  CalendarView.swift
//  FutsalGG
//
//  Created by 김태훈 on 4/16/25.
//

import SwiftUI

enum DateSelectionRestriction {
    case allowAll
    case disallowPast   // 오늘 이전 날짜 선택 불가
    case disallowFuture // 오늘 이후 날짜 선택 불가
}

struct CalendarView: View {
    @Binding var birthdayString: String
    @State private var selectedDate: Date
    @State private var tempDate: Date
    @State private var displayedMonth: Date
    @State private var isShowingDatePicker = false
    var dateRestriction: DateSelectionRestriction
    var onDismiss: () -> Void
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM"
        return formatter
    }()
    
    private let birthdayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    private let daysOfWeek = ["SUN", "MON", "TUE", "WED", "TUR", "FRI", "SAT"]
    
    init(birthdayString: Binding<String>, dateRestriction: DateSelectionRestriction = .allowAll, onDismiss: @escaping () -> Void) {
        self._birthdayString = birthdayString
        self.dateRestriction = dateRestriction
        self.onDismiss = onDismiss
        
        let initialDate: Date
        if let date = DateFormatter.yyyyMMdd.date(from: birthdayString.wrappedValue) {
            initialDate = date
        } else {
            initialDate = Date()
        }
        
        _selectedDate = State(initialValue: initialDate)
        _tempDate = State(initialValue: initialDate)
        _displayedMonth = State(initialValue: {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month], from: initialDate)
            return calendar.date(from: components)!
        }())
    }
    
    private var allDays: [Date] {
        let start = calendar.date(from: calendar.dateComponents([.year, .month], from: displayedMonth))!
        
        // 이전 달의 마지막 날짜들 계산
        let firstWeekday = calendar.component(.weekday, from: start)
        let previousMonthDays = (firstWeekday - 1)
        let previousMonthStart = calendar.date(byAdding: .day, value: -previousMonthDays, to: start)!
        
        var days: [Date] = []
        
        // 이전 달의 날짜들 추가
        for day in 0..<previousMonthDays {
            if let date = calendar.date(byAdding: .day, value: day, to: previousMonthStart) {
                days.append(date)
            }
        }
        
        // 현재 달의 날짜들 추가
        let range = calendar.range(of: .day, in: .month, for: start)!
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: start) {
                days.append(date)
            }
        }
        
        // 마지막 주의 남은 요일만큼만 다음 달의 날짜 추가
        let remainingDaysInWeek = 7 - (days.count % 7)
        if remainingDaysInWeek < 7 {
            let nextMonthStart = calendar.date(byAdding: .day, value: range.count, to: start)!
            for day in 0..<remainingDaysInWeek {
                if let date = calendar.date(byAdding: .day, value: day, to: nextMonthStart) {
                    days.append(date)
                }
            }
        }
        
        return days
    }
    
    private func moveMonth(_ value: Int) {
        if let newDate = calendar.date(byAdding: .month, value: value, to: displayedMonth) {
            displayedMonth = newDate
        }
    }
    
    var body: some View {
        VStack {
            // 월 표시
            HStack {
                Button {
                    moveMonth(-1)
                } label: {
                    Image("arrow_term_icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .rotationEffect(.degrees(180))
                }
                .frame(width: 24, height: 24)
                
                Spacer()
                
                Button {
                    tempDate = selectedDate
                    isShowingDatePicker = true
                } label: {
                    Text(dateFormatter.string(from: displayedMonth))
                        .pretendardStyle(.B_20_300)
                        .foregroundStyle(.mono900)
                        .frame(height: 24)
                }
                .sheet(isPresented: $isShowingDatePicker) {
                    VStack {
                        HStack {
                            Button("취소") {
                                isShowingDatePicker = false
                            }
                            .pretendardStyle(.R_15_100)
                            .foregroundStyle(.mono500)
                            
                            Spacer()
                            
                            Button("확인") {
                                selectedDate = tempDate
                                let components = calendar.dateComponents([.year, .month], from: tempDate)
                                displayedMonth = calendar.date(from: components)!
                                isShowingDatePicker = false
                            }
                            .pretendardStyle(.B_17_200)
                            .foregroundStyle(.mono900)
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                        
                        DatePicker(
                            "",
                            selection: $tempDate,
                            in: {
                                let calendar = Calendar.current
                                let today = calendar.startOfDay(for: Date())
                                switch dateRestriction {
                                case .allowAll:
                                    return .distantPast ... .distantFuture
                                case .disallowPast:
                                    return today ... .distantFuture
                                case .disallowFuture:
                                    return .distantPast ... today
                                }
                            }(),
                            displayedComponents: [.date]
                        )
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                        .environment(\.locale, Locale(identifier: "ko_KR"))
                        
                        Spacer()
                    }
                    .presentationDetents([.height(300)])
                }
                
                Spacer()
                
                Button {
                    moveMonth(1)
                } label: {
                    Image("arrow_term_icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                }
                .frame(width: 24, height: 24)
            }
            .frame(width: 358, height: 32)
            .padding(.top, 24)
            .padding(.bottom, 16)
            .padding(.horizontal, 16)
            
            // 요일 표시
            HStack {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(day == "SUN" ? Color.pointOrange : Color.mono500)
                        .pretendardStyle(.R_15_100)
                }
            }
            .padding(.horizontal, 16)
            
            // 날짜 그리드
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(Array(zip(allDays.indices, allDays)), id: \.0) { index, date in
                    let isCurrentMonth = calendar.isDate(date, equalTo: displayedMonth, toGranularity: .month)
                    let isDateSelectable: Bool = {
                        guard isCurrentMonth else { return false }
                        switch dateRestriction {
                        case .allowAll:
                            return true
                        case .disallowPast:
                            return calendar.compare(date, to: Date(), toGranularity: .day) != .orderedAscending
                        case .disallowFuture:
                            return calendar.compare(date, to: Date(), toGranularity: .day) != .orderedDescending
                        }
                    }()
                    let isToday = calendar.isDateInToday(date)
                    
                    Text("\(String(format: "%02d", calendar.component(.day, from: date)))")
                        .pretendardStyle(
                            calendar.isDate(date, inSameDayAs: selectedDate) ? .B_17_200 :
                            isToday ? .B_17_200 : .R_15_100
                        )
                        .foregroundStyle(
                            !isCurrentMonth ? Color.mono200 :
                            !isDateSelectable ? Color.mono200 :
                            calendar.isDate(date, inSameDayAs: selectedDate) ? .white :
                            isToday ? Color.mint500 :
                            Color.mono900
                        )
                        .frame(width: 40, height: 40)
                        .background(
                            Group {
                                if calendar.isDate(date, inSameDayAs: selectedDate) {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.mint500)
                                } else if isToday {
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.mint500)
                                }
                            }
                        )
                        .onTapGesture {
                            if isDateSelectable && isCurrentMonth {
                                selectedDate = date
                            }
                        }
                }
            }
            .padding(.horizontal, 16)
            
            VStack {
                Divider()
                    .foregroundStyle(.mono200)
                    .padding(.top, 24)
                    .padding(.bottom, 16)
                
                HStack {
                    Button {
                        birthdayString = birthdayFormatter.string(from: selectedDate)
                        onDismiss()
                    } label: {
                        Text("선택")
                            .foregroundStyle(.white)
                            .pretendardStyle(.B_20_300)
                            .frame(width: 358, height: 48)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(Color.mono900)
                    )
                }
            }
            .padding(.bottom, 48)
        }
    }
}

extension DateFormatter {
    static let yyyyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}

#Preview {
    CalendarView(birthdayString: .constant("2022-01-01"), onDismiss: {})
}
