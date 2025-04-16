//
//  SignUpView.swift
//  FutsalGG
//
//  Created by 김태훈 on 4/16/25.
//

import SwiftUI

struct SignUpView: View {
    @State var nickname: String = ""
    @State var birthday: String = ""
    
    @State var showBirthdayError: Bool = false
    @State var showNicknameError: Bool = false
    
    @State var isCalendarOpen: Bool = false
    @State private var selectedGender: Gender? = nil
    @State private var showProfileTooltip: Bool = false
    @State private var isAllowNotification: Bool = false
    
    // ADD: Nickname validation states
    @State private var nicknameErrorMessage: String = ""
    @State private var isNicknameValid: Bool = false
    @State private var isDuplicateChecked: Bool = false
    
    private enum Gender {
        case male
        case female
    }
    
    // ADD: Nickname validation function
    private func validateNickname() -> Bool {
        // Check for English characters
        let englishRegex = ".*[A-Za-z]+.*"
        if nickname.range(of: englishRegex, options: .regularExpression) != nil {
            showNicknameError = true
            nicknameErrorMessage = "영어, 특수 문자는 사용불가합니다."
            isDuplicateChecked = false
            isNicknameValid = false  // ADD: Set to false on validation failure
            return false
        }
        
        let specialCharRegex = ".*[^가-힣ㄱ-ㅎㅏ-ㅣ0-9].*"
        if nickname.range(of: specialCharRegex, options: .regularExpression) != nil {
            showNicknameError = true
            nicknameErrorMessage = "영어, 특수 문자는 사용불가합니다."
            isDuplicateChecked = false
            isNicknameValid = false  // ADD: Set to false on validation failure
            return false
        }
        
        // Check for any jamo characters (consonants or vowels)
        let jamoRegex = ".*[ㄱ-ㅎㅏ-ㅣ]+.*"
        if nickname.range(of: jamoRegex, options: .regularExpression) != nil {
            showNicknameError = true
            nicknameErrorMessage = "완성된 한글만 사용 가능합니다."
            isDuplicateChecked = false
            isNicknameValid = false  // ADD: Set to false on validation failure
            return false
        }
        
        // Check minimum length after character validation
        if nickname.count < 3 {
            showNicknameError = true
            nicknameErrorMessage = "닉네임은 3글자 이상이어야 합니다."
            isDuplicateChecked = false
            isNicknameValid = false  // ADD: Set to false on validation failure
            return false
        }
        
        showNicknameError = false
        isNicknameValid = true
        return true
    }
    
    // ADD: Check nickname duplication
    private func checkNicknameDuplication() {
        let isDuplicate = Bool.random()
        if isDuplicate {
            showNicknameError = true
            nicknameErrorMessage = "이미 존재하는 닉네임입니다."
        } else {
            showNicknameError = false
            nicknameErrorMessage = "사용 가능한 닉네임입니다."
        }
        isDuplicateChecked = true
    }
    
    var body: some View {
        ZStack {
            VStack {
                DepthHeader(title: "회원가입")
                VStack {
                    ScrollView {
                        VStack {
                            HStack {
                                Spacer()
                                Text("*필수")
                                    .pretendardStyle(.B_17_200)
                                    .foregroundStyle(.mint500)
                            }
                            .padding(.vertical, 16)
                            
                            VStack {
                                HStack(spacing: 0) {
                                    Text("닉네임")
                                        .pretendardStyle(.B_20_300)
                                        .foregroundStyle(.mono900)
                                    Text("*")
                                        .pretendardStyle(.B_20_300)
                                        .foregroundStyle(.mint500)
                                    Spacer()
                                }
                                
                                HStack {
                                    TextField("사용하실 닉네임을 입력해주세요", text: $nickname)
                                        .onChange(of: nickname) { oldValue, newValue in
                                            if !newValue.isEmpty {
                                                let isValid = validateNickname()
                                                if isValid {
                                                    isDuplicateChecked = false // Reset duplicate check when nickname changes
                                                }
                                            } else {
                                                showNicknameError = false
                                                isNicknameValid = false
                                                isDuplicateChecked = false
                                            }
                                        }
                                        .foregroundStyle(.mono900)
                                        .padding(.leading, 17)
                                        .frame(height: 48)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(strokeColor)
                                        )
                                    
                                    
                                    Button {
                                        if isNicknameValid {
                                            checkNicknameDuplication()
                                        }
                                    } label: {
                                        Text("중복확인")
                                            .foregroundStyle(nickname.isEmpty || !isNicknameValid ? .mono500 : .white)
                                            .pretendardStyle(.B_17_200)
                                            .frame(width: 78, height: 48)
                                    }
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .foregroundStyle(nickname.isEmpty || !isNicknameValid ? .mono200 : .mono900)
                                    )
                                    .disabled(nickname.isEmpty || !isNicknameValid)
                                }
                                if showNicknameError || (isDuplicateChecked && !showNicknameError) {
                                    HStack {
                                        Text(nicknameErrorMessage)
                                            .pretendardStyle(.R_17_200)
                                            .foregroundStyle(showNicknameError ? .pointOrange : .mint500)
                                        Spacer()
                                    }
                                        .padding(.leading, 16)
                                }
                            }
                            .padding(.top, 8)
                            
                            VStack {
                                HStack(spacing: 0) {
                                    Text("생년월일")
                                        .pretendardStyle(.B_20_300)
                                        .foregroundStyle(.mono900)
                                    Text("*")
                                        .pretendardStyle(.B_20_300)
                                        .foregroundStyle(.mint500)
                                    Spacer()
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        TextField("YYYY-MM-DD", text: formattedBirthdayBinding)
                                            .keyboardType(.numberPad)
                                            .padding(.leading, 17)
                                            .pretendardStyle(.R_17_200)
                                            .foregroundStyle(.mono900)
                                        
                                        Spacer()
                                        
                                        Button {
                                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                            withAnimation {
                                                isCalendarOpen = true
                                            }
                                        } label: {
                                            Image("calendar_icon")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 24, height: 24)
                                        }
                                        .padding(.trailing, 12)
                                    }
                                    .frame(width: 358, height: 48)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(showBirthdayError ? .pointOrange : formattedBirthdayBinding.wrappedValue.isEmpty ? .mono200 : .mono900)
                                    )
                                    
                                    if showBirthdayError {
                                        HStack {
                                            Text("YYYY-MM-DD의 형태로 입력해주세요.")
                                                .pretendardStyle(.R_17_200)
                                                .foregroundStyle(.pointOrange)
                                            Spacer()
                                        }
                                            .padding(.leading, 16)
                                    }
                                }
                            }
                            .padding(.top, 56)
                            
                            VStack {
                                HStack(spacing: 0) {
                                    Text("성별")
                                        .pretendardStyle(.B_20_300)
                                        .foregroundStyle(.mono900)
                                    Text("*")
                                        .pretendardStyle(.B_20_300)
                                        .foregroundStyle(.mint500)
                                    Spacer()
                                }
                                
                                HStack(spacing: 8) {
                                    Button {
                                        selectedGender = .male
                                    } label: {
                                        Text("남")
                                            .pretendardStyle(.B_17_200)
                                            .foregroundStyle(selectedGender == .male ? .white : .mono900)
                                            .frame(width: 175, height: 48)
                                    }
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(selectedGender == .male ? .clear : .mono500)
                                            .background(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(selectedGender == .male ? .mono900 : .clear)
                                            )
                                    )
                                    
                                    Button {
                                        selectedGender = .female
                                    } label: {
                                        Text("여")
                                            .pretendardStyle(.B_17_200)
                                            .foregroundStyle(selectedGender == .female ? .white : .mono900)
                                            .frame(width: 175, height: 48)
                                    }
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(selectedGender == .female ? .clear : .mono500)
                                            .background(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(selectedGender == .female ? .mono900 : .clear)
                                            )
                                    )
                                }
                            }
                            .padding(.top, 56)
                            
                            VStack {
                                HStack(spacing: 0) {
                                    Text("프로필 사진")
                                        .pretendardStyle(.B_20_300)
                                        .foregroundStyle(.mono900)
                                    
                                    Image("profile_title_icon")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 24, height: 24)
                                        .padding(.leading, 8)
                                        .onTapGesture {
                                            withAnimation {
                                                showProfileTooltip.toggle()
                                            }
                                        }
                                    
                                    Spacer()
                                }
                                
                                ZStack {
                                    Image("default_profile_img")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 120, height: 120)
                                    
                                    HStack {
                                        Spacer()
                                        
                                        VStack {
                                            Spacer()
                                            
                                            Image("add_image_icon")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 40, height: 40)
                                        }
                                    }
                                }
                                .frame(width: 136, height: 120)
                                .overlay(alignment: .top) {
                                    if showProfileTooltip {
                                        Text("사진 미 업로드시,\n기본 프로필이 적용됩니다.")
                                            .pretendardStyle(.R_17_200)
                                            .foregroundStyle(.mono900)
                                            .multilineTextAlignment(.leading)
                                            .frame(width: 202, height: 84)
                                            .background(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(.mono200)
                                                    .background(
                                                        RoundedRectangle(cornerRadius: 8)
                                                            .fill(.white)
                                                    )
                                                    
                                            )
                                            .blackShadowHard(radius:8)
                                            .offset(x: 10, y: -10)
                                    }
                                }
                            }
                            .padding(.top, 56)
                            
                            VStack {
                                HStack(alignment: .lastTextBaseline, spacing: 0) {
                                    Text("푸시 알림")
                                        .pretendardStyle(.B_20_300)
                                        .foregroundStyle(.mono900)
                                    Text("(경기 일정, 투표 등록)")
                                        .pretendardStyle(.R_17_200)
                                        .foregroundStyle(.mono500)
                                        .padding(.leading, 5)
                                    Spacer()
                                }
                                
                                HStack {
                                    Button {
                                        isAllowNotification.toggle()
                                    } label: {
                                        HStack {
                                            HStack {
                                                Image(isAllowNotification ? "checkbox_on_icon" : "checkbox_off_icon")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 24, height: 24)
                                            }
                                            .frame(width: 56, height: 56)
                                            
                                            HStack {
                                                Text("알림 받기")
                                                    .pretendardStyle(.B_17_200)
                                                    .foregroundStyle(isAllowNotification ? .mono900 : .mono500)
                                                
                                                Spacer()
                                            }
                                        }
                                        .frame(width: 358, height: 48)
                                    }
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(isAllowNotification ? .mono900 : .mono200)
                                    )
                                }
                            }
                            .padding(.top, 56)
                            .padding(.bottom, 79)
                        }
                        .padding(.horizontal, 16)
                    }
                    .simultaneousGesture(
                        TapGesture().onEnded {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            withAnimation {
                                showProfileTooltip = false
                            }
                        }
                    )
                }
                VStack {
                    Divider()
                        .foregroundStyle(.mono200)
                        .padding(.bottom, 16)
                    
                    HStack {
                        Button {
                            
                        } label: {
                            Text("회원가입")
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
            if isCalendarOpen {
                ZStack {
                    Color.black.opacity(0.5)
                        .onTapGesture {
                            isCalendarOpen = false
                        }
                    VStack {
                        Spacer()
                        CalendarView(
                            birthdayString: $birthday,
                            dateRestriction: .disallowFuture
                        ) {
                            isCalendarOpen = false
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .foregroundStyle(.white)
                        )
                    }
                    .transition(.move(edge: isCalendarOpen ? .bottom : .top))
                }
                .ignoresSafeArea()
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    private var strokeColor: Color {
        if showNicknameError {
            return .pointOrange
        } else if isDuplicateChecked && !showNicknameError {
            return .mint500
        } else if isNicknameValid {
            return .mono900
        } else {
            return .mono200
        }
    }
    
    private var formattedBirthdayBinding: Binding<String> {
        Binding(
            get: { birthday },
            set: { newValue in
                // 이미 yyyy-MM-dd 형식이면 바로 적용
                if newValue.count == 10 && newValue.contains("-") {
                    birthday = newValue
                    showBirthdayError = false
                    return
                }
                
                // 수동 입력의 경우 필터링 및 포맷팅 진행
                let filtered = newValue.filter { $0.isNumber }
                var formatted = ""
                
                let yyyy = String(filtered.prefix(4))
                if !yyyy.isEmpty {
                    formatted += yyyy
                    if filtered.count >= 4 {
                        formatted += "-"
                        let mm = String(filtered.dropFirst(4).prefix(2))
                        if !mm.isEmpty {
                            formatted += mm
                            if filtered.count >= 6 {
                                formatted += "-"
                                let dd = String(filtered.dropFirst(6).prefix(2))
                                if !dd.isEmpty {
                                    formatted += dd
                                }
                            }
                        }
                    }
                }
                
                birthday = formatted
                showBirthdayError = filtered.count != 8
            }
        )
    }
}

#Preview {
    SignUpView()
}
