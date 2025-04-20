//
//  SplashView.swift
//  FutsalGG
//
//  Created by 김태훈 on 4/19/25.
//

import SwiftUI
import Lottie

struct SplashView: View {
    @State var isAnimated: Bool = true
    
    @EnvironmentObject var rootState: RootState
    
    var body: some View {
        VStack(spacing: 0) {
            Image("main_logo")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .padding(.top, 332)
            
            Spacer()
            
            LottieView(name: "spalsh_loading_bar") {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    rootState.routeToMain()
                }
            }
            .frame(height: 8)
            .padding(.bottom, 80)
            .padding(.horizontal, 16)
        }
        .background(
            Color.mono900
                .ignoresSafeArea()
        )
    }
}

#Preview {
    SplashView()
}
