//
//  SignUpView.swift
//  FutsalGG
//
//  Created by 김태훈 on 4/16/25.
//

import SwiftUI
import Lottie
import Combine
import ComposableArchitecture

struct SignUpView: View {
    @EnvironmentObject var state: RootState
    @Environment(\.dismiss) var dismiss
    
    let store: StoreOf<SignUpFeature>
    
    @State var nickname: String = ""
    @State var birthday: String = ""
    
    @State var showBirthdayError: Bool = false
    @State var showNicknameError: Bool = false
    
    @State var isCalendarOpen: Bool = false
    @State private var selectedGender: Gender? = nil
    @State private var showProfileTooltip: Bool = false
    @State private var isAllowNotification: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var showImageEditor: Bool = false
    
    // ADD: Nickname validation states
    @State private var nicknameErrorMessage: String = ""
    @State private var isNicknameValid: Bool = false
    @State private var isDuplicateChecked: Bool = false
    @State private var selectedImage: UIImage?
    @State private var signUPSuccess: Bool = false
    @State var isLoading: Bool = false
    
    @State private var showLoading: Bool = false
    @State private var signUpSuccess: Bool = false
    
    private enum Gender {
        case male
        case female
    }
    
    // ADD: Nickname validation function
    private func validateNickname() -> Bool {
        // Check allowed characters: letters, digits, Hangul syllables, spaces
        let allowedCharactersRegex = "^[A-Za-z0-9가-힣 ]+$"
        if nickname.range(of: allowedCharactersRegex, options: .regularExpression) == nil {
            showNicknameError = true
            nicknameErrorMessage = "한글, 영어, 숫자, 띄어쓰기만 사용 가능합니다."
            isDuplicateChecked = false
            isNicknameValid = false
            return false
        }
        
        // Check for profanity words
        let profanityWords = ["시발", "씨발", "병신", "새끼", "개새끼", "미친놈", "지랄", "좆밥", "니애미", "느금마", "창녀", "매춘부"]
        if profanityWords.contains(where: { nickname.localizedCaseInsensitiveContains($0) }) {
            showNicknameError = true
            nicknameErrorMessage = "비속어는 사용하실 수 없습니다."
            isDuplicateChecked = false
            isNicknameValid = false
            return false
        }
        
        // Check minimum length after trimming spaces
        let trimmedNickname = nickname.trimmingCharacters(in: .whitespaces)
        if trimmedNickname.count < 3 {
            showNicknameError = true
            nicknameErrorMessage = "닉네임은 3글자 이상이어야 합니다."
            isDuplicateChecked = false
            isNicknameValid = false
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
    
    // ADD: 생년월일 validation helper
    private func isValidBirthday(_ dateString: String) -> (isValid: Bool, message: String?) {
        // 1. Check basic format (YYYY-MM-DD)
        let components = dateString.split(separator: "-")
        guard components.count == 3,
              let year = Int(components[0]),
              let month = Int(components[1]),
              let day = Int(components[2]) else {
            return (false, "YYYY-MM-DD 형식으로 입력해주세요.")
        }
        
        // 2. Check basic ranges
        guard year >= 1900 && year <= Calendar.current.component(.year, from: Date()),
              month >= 1 && month <= 12,
              day >= 1 && day <= 31 else {
            return (false, "올바른 날짜를 입력해주세요.")
        }
        
        // 3. Create date components and validate
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        
        guard let date = Calendar.current.date(from: dateComponents) else {
            return (false, "존재하지 않는 날짜입니다.")
        }
        
        // 4. Check if date is not in future
        guard date <= Date() else {
            return (false, "미래 날짜는 선택할 수 없습니다.")
        }
        
        // 5. Check minimum age (14세 이상)
        let now = Date()
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: date, to: now)
        guard let age = ageComponents.year, age >= 14 else {
            return (false, "14세 이상만 가입이 가능합니다.")
        }
        
        return (true, nil)
    }
    
    @State private var birthdayErrorMessage: String = "YYYY-MM-DD 형식으로 입력해주세요."
    
    private var formattedBirthdayBinding: Binding<String> {
        Binding(
            get: { birthday },
            set: { newValue in
                // 이미 yyyy-MM-dd 형식이면 validation 진행
                if newValue.count == 10 && newValue.contains("-") {
                    let validation = isValidBirthday(newValue)
                    birthday = newValue
                    showBirthdayError = !validation.isValid
                    if let message = validation.message {
                        birthdayErrorMessage = message
                    }
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
                
                // 날짜 형식이 완성되면 validation 진행
                if formatted.count == 10 {
                    let validation = isValidBirthday(formatted)
                    showBirthdayError = !validation.isValid
                    if let message = validation.message {
                        birthdayErrorMessage = message
                    }
                } else {
                    showBirthdayError = filtered.count != 8
                    birthdayErrorMessage = "YYYY-MM-DD 형식으로 입력해주세요."
                }
            }
        )
    }
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
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
                                                Text(birthdayErrorMessage)
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
                                    
                                    Button {
                                        showImagePicker = true
                                    } label: {
                                    ZStack {
                                        if let selectedImage = selectedImage {
                                            Image(uiImage: selectedImage)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 120, height: 120)
                                                .clipShape(Circle())
                                        } else {
                                            Image("default_profile_img")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 120, height: 120)
                                        }
                                        
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
                                    }
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
                                
//                                VStack {
//                                    HStack(alignment: .lastTextBaseline, spacing: 0) {
//                                        Text("푸시 알림")
//                                            .pretendardStyle(.B_20_300)
//                                            .foregroundStyle(.mono900)
//                                        Text("(경기 일정, 투표 등록)")
//                                            .pretendardStyle(.R_17_200)
//                                            .foregroundStyle(.mono500)
//                                            .padding(.leading, 5)
//                                        Spacer()
//                                    }
//                                    
//                                    HStack {
//                                        Button {
//                                            isAllowNotification.toggle()
//                                        } label: {
//                                            HStack {
//                                                HStack {
//                                                    Image(isAllowNotification ? "checkbox_on_icon" : "checkbox_off_icon")
//                                                        .resizable()
//                                                        .scaledToFit()
//                                                        .frame(width: 24, height: 24)
//                                                }
//                                                .frame(width: 56, height: 56)
//                                                
//                                                HStack {
//                                                    Text("알림 받기")
//                                                        .pretendardStyle(.B_17_200)
//                                                        .foregroundStyle(isAllowNotification ? .mono900 : .mono500)
//                                                    
//                                                    Spacer()
//                                                }
//                                            }
//                                            .frame(width: 358, height: 48)
//                                        }
//                                        .background(
//                                            RoundedRectangle(cornerRadius: 8)
//                                                .stroke(isAllowNotification ? .mono900 : .mono200)
//                                        )
//                                    }
//                                }
//                                .padding(.top, 56)
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
                            // MARK: - Button activation computed property
                            var isSignUpEnabled: Bool {
                                return isNicknameValid && // 유효한 닉네임
                                       isDuplicateChecked && !showNicknameError && // 중복 확인 완료 & 에러 없음
                                       !birthday.isEmpty && !showBirthdayError && // 생년월일 입력 & 에러 없음
                                       selectedGender != nil // 성별 선택됨
                            }
                            
                            Button {
                                viewStore.send(.signUpButtonTapped)
                            } label: {
                                Text("회원가입")
                                    .foregroundStyle(isSignUpEnabled ? .white : .mono500)
                                    .pretendardStyle(.B_20_300)
                                    .frame(width: 358, height: 48)
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundStyle(isSignUpEnabled ? .mono900 : .mono200)
                            )
                            .disabled(!isSignUpEnabled)
                        }
                    }
                    .padding(.bottom, 16)
                }
                if isCalendarOpen {
                    ZStack {
                        Color.opacityBlack
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
                
                if viewStore.showLoading {
                    LoadingView {
                        viewStore.send(.hideLoading)
                        viewStore.send(.signUpSuccess)
                    }
                }
                
                if viewStore.signUpSuccess {
                    Color.black.opacity(0.7)
                        .ignoresSafeArea()
                    
                    VStack {
                        VStack {
                            Text("\(nickname) 님")
                                .pretendardStyle(.B_20_300)
                                .foregroundStyle(.mono900)
                            Text("풋살GG 가입을 축하드립니다!")
                                .pretendardStyle(.B_20_300)
                                .foregroundStyle(.mono900)
                        }
                        .padding(.vertical, 16)
                        
                        Button {
                            viewStore.send(.confirmSignUpSuccess)
                            state.routeToMain()
                            dismiss()
                        } label: {
                            Text("확인")
                                .foregroundStyle(.white)
                                .pretendardStyle(.B_20_300)
                                .frame(width: 326, height: 48)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundStyle(.mono900)
                        )
                        .padding(.vertical, 16)
                    }
                    .frame(width: 358, height: 188)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.white)
                    )
                    .padding(.horizontal, 16)
                }
            }
        }
        .navigationBarBackButtonHidden()
        .navigationDestination(isPresented: $showImageEditor) {
            ImageEditorView(selectedImage: $selectedImage)
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $selectedImage, isShown: $showImagePicker) { image in
                selectedImage = image
                showImagePicker = false
                showImageEditor = true
            }
        }
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
}

//#Preview {
//    SignUpView()
//}

struct LottieView: UIViewRepresentable {
    let name: String
    let loopMode: LottieLoopMode
    let completion: (() -> Void)?
    
    init(name: String, loopMode: LottieLoopMode = .playOnce, completion: (() -> Void)? = nil) {
        self.name = name
        self.loopMode = loopMode
        self.completion = completion
    }
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        let animationView = LottieAnimationView()
        animationView.animation = LottieAnimation.named(name)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.play { finished in
            if finished {
                completion?()
            }
        }
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}
