//
//  TermDetailView.swift
//  FutsalGG
//
//  Created by 김태훈 on 4/15/25.
//

import SwiftUI

struct TermDetailView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var isAllowed: Bool
    
    let headerTitle: String
    let title: String
    let content: String
    
    var body: some View {
        VStack {
            DepthHeader(title: headerTitle)
            VStack {
                HStack {
                    Text(title)
                        .foregroundStyle(.mono900)
                        .pretendardStyle(.B_17_200)
                    Spacer()
                }
                .padding(.leading, 16)
                .padding(.top, 16)
                
                ScrollView {
                    HStack {
                        Text(content)
                            .foregroundStyle(.mono900)
                            .pretendardStyle(.L_15_100)
                        Spacer()
                    }
                    .padding(.leading, 16)
                }
                
                VStack {
                    Divider()
                        .foregroundStyle(.mono200)
                        .padding(.top, 27)
                        .padding(.bottom, 16)
                    
                    HStack {
                        Button {
                            isAllowed = true
                            dismiss()
                        } label: {
                            Text("동의하기")
                                .foregroundStyle(.white)
                                .pretendardStyle(.B_20_300)
                                .frame(width: 358, height: 48)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundStyle(.mono900)
                        )
                    }
                }
                .padding(.bottom, 16)
            }
        }
        .navigationBarBackButtonHidden()
    }
}
