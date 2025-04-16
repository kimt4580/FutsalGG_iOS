//
//  DepthHeader.swift
//  FutsalGG
//
//  Created by 김태훈 on 4/15/25.
//

import SwiftUI

struct DepthHeader: View {
    @Environment(\.dismiss) var dismiss
    let title: String
    
    var body: some View {
        VStack {
            HStack {
                Image("back_icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .padding(.leading, 12)
                    .onTapGesture {
                        dismiss()
                    }
                Spacer()
                
                Text(title)
                    .foregroundStyle(.mono900)
                    .pretendardStyle(.B_20_300)
                    .padding(.trailing, 36)
                Spacer()
            }
            Divider()
                .foregroundStyle(.mono200)
                .padding(.top, 9)
        }
        .frame(height: 48)
    }
}

#Preview {
    DepthHeader(title: "이용약관 동의")
}
