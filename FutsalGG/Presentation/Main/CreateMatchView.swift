//
//  CreateMatchView.swift
//  FutsalGG
//
//  Created by 김태훈 on 4/20/25.
//

import SwiftUI
import ComposableArchitecture

struct CreateMatchView: View {
    var store: StoreOf<CreateMatchFeature>
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                VStack {
                    DepthHeader(title: "경기 일정 생성하기")
                    
                    ScrollView {
                        VStack {
                            HStack {
                                Spacer()
                                Text("*필수")
                                    .pretendardStyle(.B_17_200)
                                    .foregroundStyle(.mint500)
                            }
                            .padding(.vertical, 16)
                            
                            VStack {
                                HStack {
                                    Text("날짜")
                                        .pretendardStyle(.B_20_300)
                                        .foregroundStyle(.mono900)
                                    Text("*")
                                        .pretendardStyle(.B_20_300)
                                        .foregroundStyle(.mint500)
                                    Spacer()
                                }
                                
                                HStack {
                                    TextField("YYYY-MM-DD", text: viewStore.binding(
                                        get: { $0.date },
                                        send: { .setDate($0) }
                                    ))
                                    .foregroundStyle(.mono900)
                                    .pretendardStyle(.R_17_200)
                                    .keyboardType(.numberPad)
                                    
                                    Spacer()
                                    
                                    Button {
                                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                        viewStore.send(.showCalendar)
                                    } label: {
                                        Image("calendar_icon")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 24, height: 24)
                                    }
                                }
                                .padding(.horizontal, 16)
                                .frame(height: 48)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(viewStore.date.isEmpty ? .mono200 : .mono900)
                                )
                                
                                if let dateError =  viewStore.dateError {
                                    HStack {
                                        Text(dateError)
                                            .pretendardStyle(.R_17_200)
                                            .foregroundStyle(.pointOrange)
                                        Spacer()
                                    }
                                        .padding(.leading, 16)
                                }
                            }
                            
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("장소")
                                        .pretendardStyle(.B_20_300)
                                        .foregroundStyle(.mono900)
                                    Text("*")
                                        .pretendardStyle(.B_20_300)
                                        .foregroundStyle(.mint500)
                                    Spacer()
                                }
                                
                                TextField("15자 이내로 입력해주세요.", text: viewStore.binding(
                                    get: { $0.location },
                                    send: { .setLocation($0) }
                                ))
                                .padding(.horizontal, 16)
                                .frame(height: 48)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(viewStore.locationError != nil ? .pointOrange : (viewStore.location.isEmpty ? .mono200 : .mono900))
                                )
                                
                                if let locationError = viewStore.locationError {
                                    HStack {
                                        Text(locationError)
                                            .pretendardStyle(.R_17_200)
                                            .foregroundStyle(.pointOrange)
                                        Spacer()
                                    }
                                        .padding(.leading, 16)
                                }
                            }
                            .padding(.top, 56)
                            
                            VStack {
                                HStack {
                                    Text("경기 시작 시간")
                                        .pretendardStyle(.B_20_300)
                                        .foregroundStyle(.mono900)
                                    Text("*")
                                        .pretendardStyle(.B_20_300)
                                        .foregroundStyle(.mint500)
                                    Spacer()
                                }
                                
                                VStack {
                                    VStack {
                                        Button {
                                            viewStore.send(.toggleStartTimeExpanded)
                                        } label: {
                                            HStack {
                                                Image(viewStore.isStartTimeExpanded ? "checkbox_on_icon" : "checkbox_off_icon")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 24, height: 24)
                                                
                                                Text("예정")
                                                    .pretendardStyle(.B_17_200)
                                                    .foregroundStyle(!viewStore.isStartTimeExpanded ? .mono500 : .mono900)
                                                
                                                Spacer()
                                            }
                                        }
                                        
                                        if viewStore.isStartTimeExpanded {
                                            HStack {
                                                TextField("00:00", text: viewStore.binding(
                                                    get: { $0.startTime },
                                                    send: { .setStartTime($0) }
                                                ))
                                                .keyboardType(.numberPad)
                                            }
                                            .padding(.horizontal, 16)
                                            .frame(height: 48)
                                            .background(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(.mono500)
                                            )
                                        }
                                    }
                                    .padding(.all, 16)
                                    .frame(minHeight: 58, maxHeight: 125)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(viewStore.isStartTimeExpanded ? .mono900 : .mono200)
                                    )
                                }
                                
                                Button {
                                    viewStore.send(.toggleStartTimeExpanded)
                                } label: {
                                    HStack {
                                        Image(!viewStore.isStartTimeExpanded ? "checkbox_on_icon" : "checkbox_off_icon")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 24, height: 24)
                                        
                                        Text("미정")
                                            .pretendardStyle(.B_17_200)
                                            .foregroundStyle(viewStore.isStartTimeExpanded ? .mono500 : .mono900)
                                        
                                        Spacer()
                                    }
                                }
                                .padding(.all, 16)
                                .frame(height: 58)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(!viewStore.isEndTimeExpanded ? .mono900 : .mono200)
                                )
                            }
                            .padding(.top, 56)
                            
                            VStack {
                                HStack {
                                    Text("경기 종료 시간")
                                        .pretendardStyle(.B_20_300)
                                        .foregroundStyle(.mono900)
                                    Text("*")
                                        .pretendardStyle(.B_20_300)
                                        .foregroundStyle(.mint500)
                                    Spacer()
                                }
                                
                                VStack {
                                    VStack {
                                        Button {
                                            viewStore.send(.toggleEndTimeExpanded)
                                        } label: {
                                            HStack {
                                                Image(viewStore.isEndTimeExpanded ? "checkbox_on_icon" : "checkbox_off_icon")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 24, height: 24)
                                                
                                                Text("예정")
                                                    .pretendardStyle(.B_17_200)
                                                    .foregroundStyle(!viewStore.isEndTimeExpanded ? .mono500 : .mono900)
                                                
                                                Spacer()
                                            }
                                        }
                                        
                                        if viewStore.isEndTimeExpanded {
                                            HStack {
                                                TextField("00:00", text: viewStore.binding(
                                                    get: { $0.endTime },
                                                    send: { .setEndTime($0) }
                                                ))
                                                .keyboardType(.numberPad)
                                            }
                                            .padding(.horizontal, 16)
                                            .frame(height: 48)
                                            .background(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(.mono500)
                                            )
                                        }
                                    }
                                    .padding(.all, 16)
                                    .frame(minHeight: 58, maxHeight: 125)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(viewStore.isEndTimeExpanded ? .mono900 : .mono200)
                                    )
                                    
                                    Button {
                                        viewStore.send(.toggleEndTimeExpanded)
                                    } label: {
                                        HStack {
                                            Image(!viewStore.isEndTimeExpanded ? "checkbox_on_icon" : "checkbox_off_icon")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 24, height: 24)
                                            
                                            Text("미정")
                                                .pretendardStyle(.B_17_200)
                                                .foregroundStyle(viewStore.isEndTimeExpanded ? .mono500 : .mono900)
                                            
                                            Spacer()
                                        }
                                    }
                                    .padding(.all, 16)
                                    .frame(height: 58)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(!viewStore.isEndTimeExpanded ? .mono900 : .mono200)
                                    )
                                }
                            }
                            .padding(.top, 56)
                            
                            VStack {
                                HStack {
                                    Text("대리 기록자 선택")
                                        .pretendardStyle(.B_20_300)
                                        .foregroundStyle(.mono900)
                                    Spacer()
                                }
                                
                                HStack {
//                                    TextField(
//                                        "닉네임을 입력해주세요.",
//                                        text: viewStore.binding(
//                                            get: { $0.findTeam?.searchTeamName ?? "" },
//                                            send: { .findTeam(.setSearchTeamName($0)) }
//                                        )
//                                    )
//                                    .pretendardStyle(.R_17_200)
//                                    .foregroundStyle(.mono900)
//                                    .frame(height: 48)
//                                    .padding(.horizontal, 17)
//                                    .onSubmit {
//                                        viewStore.send(.findTeam(.searchTeams))
//                                    }
                                    Spacer()
                                    
                                    Button {
//                                        viewStore.send(.findTeam(.searchTeams))
                                    } label: {
                                        HStack {
                                            Image("search_icon")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 24, height: 24)
                                        }
                                        .frame(width: 48, height: 48)
                                    }
                                }
                                .frame(height: 48)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(.mono300)
                                )
                            }
                            .padding(.all, 16)
                            .blackShadowSoft(radius: 0)
                        }
                        .padding(.horizontal, 16)
                        
                    }
                    .simultaneousGesture(
                        TapGesture().onEnded {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }
                    )
                    
                    VStack {
                        Divider()
                            .foregroundStyle(.mono200)
                        
                        Button {
                            viewStore.send(.createButtonTapped)
                        } label: {
                            Text("생성하기")
                                .foregroundStyle(.white)
                                .pretendardStyle(.B_20_300)
                                .frame(height: 48)
                                .frame(maxWidth: .infinity)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundStyle(viewStore.isFormValid ? .mono900 : .mono200)
                        )
                        .disabled(!viewStore.isFormValid)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 16)
                    }
                }
                
                if viewStore.showCalendar {
                    ZStack {
                        Color.opacityBlack
                            .onTapGesture {
                                viewStore.send(.showCalendar)
                            }
                        
                        VStack {
                            Spacer()
                            CalendarView(
                                birthdayString: viewStore.binding(
                                    get: { $0.date },
                                    send: { .setDate($0) }
                                ),
                                dateRestriction: .disallowPast
                            ) {
                                viewStore.send(.showCalendar)
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .foregroundStyle(.white)
                            )
                        }
                    }
                    .ignoresSafeArea()
                }
                
                if viewStore.showLoading {
                    LoadingView {
                        viewStore.send(.hideLoading)
                        viewStore.send(.createSuccess)
                    }
                }
                
                if viewStore.createSuccess {
                    Color.black.opacity(0.7)
                        .ignoresSafeArea()
                    
                    VStack {
                        Text("경기 일정이 생성되었습니다!")
                            .pretendardStyle(.B_20_300)
                            .foregroundStyle(.mono900)
                            .padding(.vertical, 16)
                        
                        Button {
                            viewStore.send(.confirmCreateSuccess)
                            dismiss()
                        } label: {
                            Text("확인")
                                .foregroundStyle(.white)
                                .pretendardStyle(.B_20_300)
                                .frame(width: 326, height: 48)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundStyle(.mono900)
                        )
                        .padding(.vertical, 16)
                    }
                    .frame(width: 358, height: 188)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.white)
                    )
                    .padding(.horizontal, 16)
                }
            }
            .onAppear {
                viewStore.send(.reset)
            }
        }
        .navigationBarBackButtonHidden()
    }
}
