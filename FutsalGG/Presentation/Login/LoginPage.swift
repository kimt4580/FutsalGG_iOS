//
//  LoginPage.swift
//  FutsalGG
//
//  Created by 김태훈 on 3/21/25.
//

import SwiftUI
import ComposableArchitecture

struct LoginPage: View {
    var body: some View {
        VStack {
            VStack {
                Image("main_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .padding(.top, 128)
                
                Spacer()
                
                VStack {
                    NavigationLink {
                        SignUpPage()
                    } label: {
                        HStack {
                            Image(systemName: "apple.logo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundStyle(.white)
                                .padding(.leading, 24)
                            
                            Spacer()
                            
                            Text("Apple로 시작하기")
                                .foregroundStyle(.white)
                                .pretendardStyle(.R_20_300)
                                .padding(.trailing, 40)
                            
                            Spacer()
                        }
                        .frame(width: 358, height: 48)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .foregroundStyle(.mono900)
                    )
                    .whiteShadowSoft(radius: 16)
                    .padding(.bottom, 160)
                }
            }
            Spacer()
        }
        .background(
            Image("login_background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea(edges: .vertical)
        )
    }
}

#Preview {
    LoginPage()
}
