//
//  SignUpPage.swift
//  FutsalGG
//
//  Created by 김태훈 on 4/18/25.
//

import SwiftUI
import ComposableArchitecture

struct SignUpPage: View {
    @StateObject var signUpState: SignUpState = SignUpState()
    
    var body: some View {
        Group {
            switch signUpState.destination {
                case .term:
                TermView(store: Store(initialState: TermFeature.State()) {
                    TermFeature()
                })
            case .signUp:
                SignUpView(store: Store(initialState: SignUpFeature.State()) {
                    SignUpFeature()
                })
            }
        }
        .environmentObject(signUpState)
    }
}

class SignUpState: ObservableObject {
    @Published private(set) var destination: Destination = .term
    
    enum Destination {
        case term
        case signUp
    }
    
    func routeToSignUp() {
        withAnimation {
            destination = .signUp
        }
    }
    
    func routeToTerm() {
        withAnimation {
            destination = .term
        }
    }
}

