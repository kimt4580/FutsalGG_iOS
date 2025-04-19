//
//  RootView.swift
//  FutsalGG
//
//  Created by 김태훈 on 3/26/25.
//

import SwiftUI

struct RootView: View {
    @ObservedObject var rootState: RootState = RootState()
    
    var body: some View {
        NavigationStack {
            Group {
                switch rootState.destination {
                case .login:
                    LoginPage()
                case .main:
                    MainPage()
                case .splash:
                    SplashView()
                }
            }
        }
        .environmentObject(rootState)
    }
}

#Preview {
    RootView()
}

class RootState: ObservableObject {
    @Published private(set) var destination: Destination = .main
    
    enum Destination {
        case login
        case main
        case splash
    }
    
    func routeToLogin() {
        withAnimation {
            destination = .login
        }
    }
    
    func routeToMain() {
        withAnimation {
            destination = .main
        }
    }
    
    func routeToSplash() {
        withAnimation {
            destination = .splash
        }
    }
}
