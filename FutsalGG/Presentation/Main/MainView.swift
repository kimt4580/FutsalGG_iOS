//
//  MainView.swift
//  FutsalGG
//
//  Created by 김태훈 on 4/20/25.
//

import SwiftUI

struct MainView: View {
    let teamName: String
    
    var body: some View {
        VStack {
            HStack {
                HStack {
                    Text(teamName)
                }
                Spacer()
                Image("setting_icon")
            }
        }
    }
}
