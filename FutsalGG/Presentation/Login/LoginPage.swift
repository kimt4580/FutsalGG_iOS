//
//  LoginPage.swift
//  FutsalGG
//
//  Created by 김태훈 on 3/21/25.
//

import SwiftUI

struct LoginPage: View {
    var body: some View {
        VStack {
            Spacer()
        VStack {
            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(Color.init("#D9D9D9"))
                .frame(width: 120, height: 120)
                .padding(.top, 80)
            
            VStack {
                Button {
                    
                } label: {
                    HStack {
                        Image(systemName: "apple.logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(.white)
                            .padding(.leading, 30)
                        
                        Spacer()
                        
                        Text("Apple로 시작하기")
                            .foregroundStyle(.white)
                            .bold()
                            .padding(.trailing, 40)
                        
                        Spacer()
                    }
                }
                .frame(width: 328, height: 48)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                )
                .padding(.top, 476)
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
