//
//  TermView.swift
//  FutsalGG
//
//  Created by 김태훈 on 4/15/25.
//

import SwiftUI

struct TermView: View {
    @State var isServiceTermChecked: Bool = false
    @State var isPrivacyTermChecked: Bool = false
    
    var isAllChecked: Bool {
        isServiceTermChecked && isPrivacyTermChecked
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("이용약관 동의")
                    .foregroundStyle(.black)
                    .pretendardStyle(.B_40_500)
                Spacer()
            }
            .padding(.top, 80)
            .padding(.leading, 16)
            
            HStack {
                Text("풋살 앱 서비스의 원할한 이용을 위해\n아래 약관에 동의해주세요.")
                    .foregroundStyle(.black)
                    .pretendardStyle(.R_20_300)
                Spacer()
            }
            .padding(.top, 8)
            .padding(.leading, 16)
            
            Spacer()
            
            HStack {
                Button {
                    let newValue = !isAllChecked
                    isServiceTermChecked = newValue
                    isPrivacyTermChecked = newValue
                } label: {
                    HStack {
                        Image(isAllChecked ? "checkbox_on_icon" : "checkbox_off_icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    }
                    .frame(width: 56, height: 56)
                }
                
                Text("전체 선택")
                    .foregroundStyle(.mono900)
                    .pretendardStyle(.B_17_200)
                
                Spacer()
            }
            .padding(.leading, 16)
            
            TermItemView(
                isChecked: $isServiceTermChecked,
                title: "이용약관 동의 (필수)",
                headerTitle: "이용약관 동의",
                content: "이용약관에 대한 내용을 적어주세요."
            )
            TermItemView(
                isChecked: $isPrivacyTermChecked,
                title:"개인정보 수집 및 이용 동의 (필수)",
                headerTitle: "개인정보 수집 및 이용 동의",
                content: "이용약관에 대한 내용을 적어주세요."
            )
            
            VStack {
                Divider()
                    .foregroundStyle(.mono200)
                    .padding(.top, 27)
                    .padding(.bottom, 16)
                
                HStack {
                    NavigationLink {
                        SignUpView()
                    } label: {
                        Text("동의하기")
                            .foregroundStyle(.white)
                            .pretendardStyle(.B_20_300)
                            .frame(width: 358, height: 48)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(isAllChecked ? Color.mono900 : Color.mono200)
                    )
                }
            }
            .padding(.bottom, 16)
        }
        .navigationBarBackButtonHidden()
    }
}

struct TermItemView: View {
    @Binding var isChecked: Bool
    
    let title: String
    let headerTitle: String
    let content: String
    
    var body: some View {
        HStack {
            Button {
                isChecked.toggle()
            } label: {
                HStack {
                    Image(isChecked ? "checkbox_on_icon" : "checkbox_off_icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                }
                .frame(width: 56, height: 56)
            }
            
            NavigationLink {
                TermDetailView(isAllowed: $isChecked, headerTitle: headerTitle, title: title, content: content)
            } label: {
                HStack {
                    Text(title)
                        .foregroundStyle(.mono900)
                        .pretendardStyle(.R_17_200)
                    
                    Spacer()
                    
                    Image("arrow_term_icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .padding(.trailing, 20)
                    
                }
            }
        }
        .frame(width: 358, height: 56)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isChecked ? Color.mono900 : Color.mono200)
        )
    }
}

#Preview {
    TermView()
}
