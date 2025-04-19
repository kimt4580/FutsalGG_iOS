//
//  NoTeamPage.swift
//  FutsalGG
//
//  Created by 김태훈 on 4/19/25.
//

import SwiftUI
import ComposableArchitecture

struct NoTeamPage: View {
    var body: some View {
        VStack(spacing: 0) {
            NavigationLink {
                MakeTeamPage(store: Store(initialState: TeamFeature.State()) {
                    TeamFeature()
                })
            } label: {
                ZStack {
                    Image("make_team_img")
                        .resizable()
                        .scaledToFill()
                    VStack {
                        Spacer()
                        Text("팀 생성하기")
                            .pretendardStyle(.B_24_400)
                            .foregroundStyle(.white)
                    }
                    .padding(.bottom, 80)
                }
            }
            
            Button {
                
            } label: {
                ZStack {
                    Image("join_team_img")
                        .resizable()
                        .scaledToFill()
                    VStack {
                        Text("팀 가입하기")
                            .pretendardStyle(.B_24_400)
                            .foregroundStyle(.mono900)
                        Spacer()
                    }
                    .padding(.top, 80)
                }
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    NoTeamPage()
}
