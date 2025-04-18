//
//  RootView.swift
//  FutsalGG
//
//  Created by 김태훈 on 3/26/25.
//

import SwiftUI

struct RootView: View {
    @StateObject var rootState: RootState = RootState()
    
    var body: some View {
        NavigationStack {
            Group {
                switch rootState.destination {
                case .login:
                    LoginPage()
                case .main:
                    MainPage()
                }
            }
            .environmentObject(rootState)
        }
    }
}

#Preview {
    RootView()
}

class RootState: ObservableObject {
    @Published private(set) var destination: Destination = .login
    
    enum Destination {
        case login
        case main
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
}
