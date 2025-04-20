//
//  FindTeamPage.swift
//  FutsalGG
//
//  Created by 김태훈 on 4/20/25.
//

import SwiftUI
import ComposableArchitecture

struct FindTeamPage: View {
    @Environment(\.dismiss) var dismiss
    let store: StoreOf<TeamFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                VStack {
                    DepthHeader(title: "팀 가입하기")
                    
                    VStack {
                        HStack {
                            Text("가입하고자 하는 팀을 검색해보세요!")
                                .pretendardStyle(.B_20_300)
                                .foregroundStyle(.mono900)
                            Spacer()
                        }
                        
                        HStack {
                            TextField("팀 명을 입력해주세요.", text: viewStore.binding(
                                get: \.searchTeamName,
                                send: TeamFeature.Action.setSearchTeamName
                            ))
                            .pretendardStyle(.R_17_200)
                            .foregroundStyle(.mono900)
                            .frame(height: 48)
                            .padding(.horizontal, 17)
                            .onSubmit {
                                viewStore.send(.searchTeams)
                            }
                            Spacer()
                            
                            Button {
                                viewStore.send(.searchTeams)
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
                    
                    if viewStore.teams.isEmpty {
                        Spacer()
                        Image("search_empty_img")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 196)
                        Spacer()
                    } else {
                        ScrollView {
                            ForEach(viewStore.teams) { team in
                                FindTeamElement(
                                    store: store,
                                    teamID: team.id,
                                    teamName: team.teamName,
                                    teamLeaderName: team.teamLeaderName,
                                    teamMemberCount: team.teamMemberCount
                                )
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                            }
                        }
                    }
                    
                    VStack {
                        Divider()
                            .foregroundStyle(.mono200)
                            .padding(.bottom, 16)
                        
                        Button {
                            viewStore.send(.joinButtonTapped)
                        } label: {
                            Text("가입 신청하기")
                                .foregroundStyle(isCreateEnabled(viewStore) ? .white : .mono500)
                                .pretendardStyle(.B_20_300)
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundStyle(isCreateEnabled(viewStore) ? .mono900 : .mono200)
                        )
                        .disabled(!isCreateEnabled(viewStore))
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)
                    }
                }
                
                if viewStore.showLoading {
                    LoadingView {
                        viewStore.send(.hideLoading)
                        viewStore.send(.joinSuccess)
                    }
                }
                
                if viewStore.showJoinConfirmation {
                    Color.black.opacity(0.7)
                        .ignoresSafeArea()
                    
                    VStack {
                        VStack {
                            if let selectedID = viewStore.selectedTeamID,
                               let selectedTeam = viewStore.teams.first(where: { $0.id == selectedID }) {
                                Text("\(selectedTeam.teamName) 팀에")
                                    .pretendardStyle(.B_20_300)
                                    .foregroundStyle(.mono900)
                            }
                            Text("가입을 신청하시겠습니까?")
                                .pretendardStyle(.B_20_300)
                                .foregroundStyle(.mono900)
                        }
                        .padding(.vertical, 16)
                        
                        HStack(spacing: 16) {
                            Button {
                                viewStore.send(.cancelJoin)
                            } label: {
                                Text("취소")
                                    .foregroundStyle(.mono500)
                                    .pretendardStyle(.B_20_300)
                                    .frame(width: 155, height: 48)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(.mono500)
                                    )
                            }
                            
                            Button {
                                viewStore.send(.confirmJoin)
                            } label: {
                                Text("확인")
                                    .foregroundStyle(.white)
                                    .pretendardStyle(.B_20_300)
                                    .frame(width: 155, height: 48)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .foregroundStyle(.mono900)
                                    )
                            }
                        }
                        .padding(.vertical, 16)
                    }
                    .frame(width: 358, height: 188)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.white)
                    )
                    .padding(.horizontal, 16)
                }
                
                if viewStore.showJoinSuccess {
                    Color.black.opacity(0.7)
                        .ignoresSafeArea()
                    
                    VStack {
                        VStack {
                            Text("가입 신청이 완료되었습니다.")
                                .pretendardStyle(.B_20_300)
                                .foregroundStyle(.mono900)
                            VStack {
                                Text("해당 팀에서 가입 신청 수락시")
                                    .pretendardStyle(.R_17_200)
                                    .foregroundStyle(.mono700)
                                Text("팀에 가입이 완료됩니다.")
                                    .pretendardStyle(.R_17_200)
                                    .foregroundStyle(.mono700)
                            }
                            .padding(.top, 8)
                        }
                        .padding(.vertical, 16)
                        
                        Button {
                            viewStore.send(.confirmJoinSuccess)
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
                    .frame(width: 358, height: 218)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.white)
                    )
                    .padding(.horizontal, 16)
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    private func isCreateEnabled(_ viewStore: ViewStore<TeamFeature.State, TeamFeature.Action>) -> Bool {
        return viewStore.selectedTeamID != nil
    }
}

struct FindTeamElement: View {
    let store: StoreOf<TeamFeature>
    let teamID: String
    let teamName: String
    let teamLeaderName: String
    let teamMemberCount: String
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Button {
                viewStore.send(.selectTeam(teamID))
            } label: {
                VStack {
                    HStack {
                        Text(teamName)
                            .pretendardStyle(.B_20_300)
                            .foregroundStyle(.mono900)
                        
                        Spacer()
                    }
                    
                    HStack {
                        Text(teamLeaderName)
                            .foregroundStyle(viewStore.selectedTeamID == teamID ? .mint300 : .mono900)
                        Spacer()
                        
                        HStack {
                            Image("list_profile_icon")
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundStyle(viewStore.selectedTeamID == teamID ? .white : .mono500)
                                .padding(.leading, 3)
                            
                            Text(teamMemberCount)
                                .foregroundStyle(viewStore.selectedTeamID == teamID ? .white : .mono500)
                                .pretendardStyle(.R_17_200)
                                .padding(.trailing, 8)
                        }
                        .frame(width: 56, height: 26)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundStyle(viewStore.selectedTeamID == teamID ? .mint300 : .mono50)
                        )
                    }
                    .padding(.top, 8)
                }
                .padding(.all, 16)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(viewStore.selectedTeamID == teamID ? .mint50 : .white)
                )
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(viewStore.selectedTeamID == teamID ? .mint500 : .mono300)
                )
            }
        }
    }
}
