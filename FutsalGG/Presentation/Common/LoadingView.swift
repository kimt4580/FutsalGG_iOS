//
//  LoadingView.swift
//  FutsalGG
//
//  Created by 김태훈 on 4/20/25.
//

import SwiftUI

struct LoadingView: View {
    var onFinish: () -> Void = {}
    
    var body: some View {
        Color.white
            .ignoresSafeArea()
        
        VStack {
            LottieView(name: "loading") {
                onFinish()
            }
            .frame(width: 190, height: 190)
            
            Text("잠시만 기다려 주세요")
                .pretendardStyle(.B_24_400)
                .foregroundStyle(.mono900)
        }
    }
}

#Preview {
    LoadingView()
}
