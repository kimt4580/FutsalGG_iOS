//
//  SearchSelectView.swift
//  FutsalGG
//
//  Created by 김태훈 on 5/7/25.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

struct SearchSelectView: View {
    let title: String
    let placeholder: String
    
    
    var body: some View {
        VStack {
            
        }
    }
}

struct SearchSelectElement: View {
    let selected: Bool
    let image: String?
    let nickName: String
    let accessLevel: AccessLevel
    
    var body: some View {
        HStack {
            Image(selected ? "checkbox_on_icon" : "checkbox_off_icon")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
            if let image {
                WebImage(url: URL(string: image)!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
            } else {
                Image("default_profile_img")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
            }
            
            Text(nickName)
                .pretendardStyle(.B_17_200)
                .foregroundStyle(.mono900)
                .padding(.leading, 8)
            
            Spacer()
            
            Group {
                switch accessLevel {
                case .owner:
                    Text("설립자")
                        .pretendardStyle(.R_17_200)
                        .foregroundStyle(.mono900)
                case .leader:
                    Text("팀장")
                        .pretendardStyle(.R_17_200)
                        .foregroundStyle(.mono900)
                case .deputyLeader:
                    Text("부팀장")
                        .pretendardStyle(.R_17_200)
                        .foregroundStyle(.mono900)
                case .secretary:
                    Text("총무")
                        .pretendardStyle(.R_17_200)
                        .foregroundStyle(.mono900)
                case .member:
                    Text("멤버")
                        .pretendardStyle(.R_17_200)
                        .foregroundStyle(.mono900)
                }
            }
            .frame(width: 56)
            .padding(.trailing, 16)
        }
        .frame(height: 48)
    }
}
