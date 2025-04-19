//
//  MainPage.swift
//  FutsalGG
//
//  Created by 김태훈 on 4/18/25.
//

import SwiftUI

struct MainPage: View {
    @StateObject var mainState: MainState = MainState()
    
    var body: some View {
        Group {
            switch mainState.destination {
            case .home:
                HomePage()
            case .noTeam:
                NoTeamPage()
            }
        }
        .environmentObject(mainState)
    }
}

class MainState: ObservableObject {
    @Published private(set) var destination: Destination = .noTeam
    
    enum Destination {
        case home
        case noTeam
    }
    
    func routeToHome() {
        withAnimation {
            destination = .home
        }
    }
    
    func routeToNoTeam() {
        withAnimation {
            destination = .noTeam
        }
    }
}
