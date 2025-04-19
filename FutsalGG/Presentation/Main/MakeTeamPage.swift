//
//  MakeTaemPage.swift
//  FutsalGG
//
//  Created by 김태훈 on 4/19/25.
//

import SwiftUI
import ComposableArchitecture

struct MakeTeamPage: View {
    @EnvironmentObject var state: RootState
    @Environment(\.dismiss) var dismiss
    
    let store: StoreOf<TeamFeature>
    
    @State private var showImagePicker: Bool = false
    @State private var showImageEditor: Bool = false
    @State private var selectedImage: UIImage?
    
    private func validateTeamName(_ teamName: String) -> Bool {
        let allowedCharactersRegex = "^[A-Za-z0-9가-힣 ]+$"
        if teamName.range(of: allowedCharactersRegex, options: .regularExpression) == nil {
            return false
        }
        
        let profanityWords = ["시발", "씨발", "병신", "새끼", "개새끼", "미친놈", "지랄", "좆밥", "니애미", "느금마", "창녀", "매춘부"]
        if profanityWords.contains(where: { teamName.localizedCaseInsensitiveContains($0) }) {
            return false
        }
        
        let trimmedTeamName = teamName.trimmingCharacters(in: .whitespaces)
        if trimmedTeamName.count < 3 {
            return false
        }
        
        return true
    }
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                VStack {
                    DepthHeader(title: "팀 생성하기")
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
                                    Text("팀 명")
                                        .pretendardStyle(.B_20_300)
                                        .foregroundStyle(.mono900)
                                    Text("*")
                                        .pretendardStyle(.B_20_300)
                                        .foregroundStyle(.mint500)
                                    Spacer()
                                }
                                
                                HStack {
                                    TextField("팀 이름을 입력해주세요", text: viewStore.binding(
                                        get: \.teamName,
                                        send: TeamFeature.Action.setTeamName
                                    ))
                                    .onChange(of: viewStore.teamName) { oldValue, newValue in
                                        if !newValue.isEmpty {
                                            viewStore.send(.validateTeamName)
                                        }
                                    }
                                    .foregroundStyle(.mono900)
                                    .pretendardStyle(.R_17_200)
                                    .padding(.leading, 17)
                                    .frame(height: 48)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(strokeColor(viewStore))
                                    )
                                    
                                    Button {
                                        if viewStore.isTeamNameValid {
                                            viewStore.send(.checkTeamNameDuplicate)
                                        }
                                    } label: {
                                        Text("중복확인")
                                            .foregroundStyle(viewStore.teamName.isEmpty || !viewStore.isTeamNameValid ? .mono500 : .white)
                                            .pretendardStyle(.B_17_200)
                                            .frame(width: 78, height: 48)
                                    }
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .foregroundStyle(viewStore.teamName.isEmpty || !viewStore.isTeamNameValid ? .mono200 : .mono900)
                                    )
                                    .disabled(viewStore.teamName.isEmpty || !viewStore.isTeamNameValid)
                                }
                                
                                if viewStore.showTeamNameError {
                                    HStack {
                                        Text(viewStore.teamNameErrorMessage)
                                            .pretendardStyle(.R_17_200)
                                            .foregroundStyle(.pointOrange)
                                        Spacer()
                                    }
                                } else if viewStore.isDuplicateChecked {
                                    HStack {
                                        Text(viewStore.teamNameSuccessMessage)
                                            .pretendardStyle(.R_17_200)
                                            .foregroundStyle(.mint500)
                                        Spacer()
                                    }
                                }
                            }
                            .padding(.top, 8)
                            
                            VStack {
                                HStack {
                                    Text("팀 소개")
                                        .pretendardStyle(.B_20_300)
                                        .foregroundStyle(.mono900)
                                    Spacer()
                                }
                                
                                TextField("팀의 소개를 작성해주세요 (20자 이내)", text: viewStore.binding(
                                    get: \.teamDescription,
                                    send: TeamFeature.Action.setTeamDescription
                                ))
                                .foregroundStyle(.mono900)
                                .frame(height: 80)
                                .padding(.horizontal, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(.mono200)
                                )
                            }
                            .padding(.top, 56)
                            
                            VStack {
                                HStack {
                                    Text("팀 규칙")
                                        .pretendardStyle(.B_20_300)
                                        .foregroundStyle(.mono900)
                                    Spacer()
                                }
                                
                                TextField("팀의 규칙을 작성해주세요. (일정, 회비, 계좌번호 등)", text: viewStore.binding(
                                    get: \.teamRule,
                                    send: TeamFeature.Action.setTeamRules
                                ), axis: .vertical)
                                .foregroundStyle(.mono900)
                                .multilineTextAlignment(.leading)
                                .lineLimit(1...5)
                                .frame(height: 80)
                                .padding(.horizontal, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(.mono200)
                                )
                            }
                            .padding(.top, 56)
                            
                            VStack {
                                HStack(spacing: 0) {
                                    Text("관리자 범위")
                                        .pretendardStyle(.B_20_300)
                                        .foregroundStyle(.mono900)
                                    
                                    Text("*")
                                        .pretendardStyle(.B_20_300)
                                        .foregroundStyle(.mint500)
                                    Spacer()
                                }
                                
                                Button {
                                    viewStore.send(.toggleDropdown(.managerRange))
                                } label: {
                                    HStack {
                                        Text(viewStore.selectedManagerRange?.rawValue ?? "선택하기")
                                            .pretendardStyle(.R_17_200)
                                            .foregroundStyle(.mono900)
                                        Spacer()
                                        Image(systemName: "chevron.down")
                                            .foregroundStyle(.mono900)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 48)
                                    .padding(.horizontal, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(.mono200)
                                    )
                                }
                                
                                if viewStore.showDropdown == .managerRange {
                                    VStack(spacing: 0) {
                                        ForEach(TeamFeature.State.ManagerRange.allCases, id: \.self) { range in
                                            Button {
                                                viewStore.send(.setManagerRange(range))
                                            } label: {
                                                HStack {
                                                    Spacer()
                                                    Text(range.rawValue)
                                                        .pretendardStyle(.R_17_200)
                                                        .foregroundStyle(.mono900)
                                                    Spacer()
                                                }
                                                .frame(maxWidth: .infinity)
                                                .frame(height: 48)
                                                .padding(.horizontal, 16)
                                                .background(viewStore.selectedManagerRange == range ? Color.mint100 : .clear)
                                            }
                                        }
                                    }
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(.mono200)
                                    )
                                }
                            }
                            .padding(.top, 56)
                            
                            VStack {
                                HStack(spacing: 0) {
                                    Text("회비")
                                        .pretendardStyle(.B_20_300)
                                        .foregroundStyle(.mono900)
                                    Text("*")
                                        .pretendardStyle(.B_20_300)
                                        .foregroundStyle(.mint500)
                                    Spacer()
                                }
                                
                                HStack {
                                    TextField("회비를 입력해주세요", text: viewStore.binding(
                                        get: \.membershipFee,
                                        send: TeamFeature.Action.setMembershipFee
                                    ))
                                    .keyboardType(.numberPad)
                                    .textContentType(.none)
                                    .autocorrectionDisabled()
                                    .textInputAutocapitalization(.never)
                                    .disabled(false)
                                    
                                    Text("만원")
                                        .pretendardStyle(.R_17_200)
                                        .foregroundStyle(.mono900)
                                }
                                .padding(.horizontal, 16)
                                .frame(height: 48)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(.mono200)
                                )
                            }
                            .padding(.top, 56)
                            
                            VStack {
                                HStack(spacing: 0) {
                                    Text("로고")
                                        .pretendardStyle(.B_20_300)
                                        .foregroundStyle(.mono900)
                                    
                                    Text("*")
                                        .pretendardStyle(.B_20_300)
                                        .foregroundStyle(.mint500)
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
                                            Image("default_team_img")
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
                            }
                            .padding(.top, 56)
                            .padding(.bottom, 57)
                        }
                        .padding(.horizontal, 16)
                    }
                    .simultaneousGesture(
                        TapGesture().onEnded {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }
                    )
                    
                    VStack {
                        Divider()
                            .foregroundStyle(.mono200)
                            .padding(.bottom, 16)
                        
                        Button {
                            viewStore.send(.makeTeamButtonTapped)
                        } label: {
                            Text("생성하기")
                                .foregroundStyle(isCreateEnabled(viewStore) ? .white : .mono500)
                                .pretendardStyle(.B_20_300)
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundStyle(isCreateEnabled(viewStore) ? .mono900 : .mono200)
                        )
                        .disabled(!isCreateEnabled(viewStore))
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)
                    }
                }
                
                if viewStore.showLoading {
                    LoadingView {
                        viewStore.send(.hideLoading)
                        viewStore.send(.makeTeamSuccess)
                    }
                }
                
                if viewStore.makeTeamSuccess {
                    Color.black.opacity(0.7)
                        .ignoresSafeArea()
                    
                    VStack {
                        VStack {
                            Text("\(viewStore.teamName)")
                                .pretendardStyle(.B_20_300)
                                .foregroundStyle(.mono900)
                            Text("팀이 생성되었습니다!")
                                .pretendardStyle(.B_20_300)
                                .foregroundStyle(.mono900)
                        }
                        .padding(.vertical, 16)
                        
                        Button {
                            viewStore.send(.confirmMakeTeamSuccess)
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
            .navigationBarBackButtonHidden()
            .navigationDestination(isPresented: $showImageEditor) {
                ImageEditorView(selectedImage: $selectedImage)
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $selectedImage, isShown: $showImagePicker) { image in
                    selectedImage = image
                    viewStore.send(.setTeamLogoImage(image))
                    showImagePicker = false
                    showImageEditor = true
                }
            }
        }
    }
    
    private func strokeColor(_ viewStore: ViewStore<TeamFeature.State, TeamFeature.Action>) -> Color {
        if viewStore.showTeamNameError {
            return .pointOrange
        } else if viewStore.isDuplicateChecked && !viewStore.showTeamNameError {
            return .mint500
        } else if viewStore.isTeamNameValid {
            return .mono900
        } else {
            return .mono200
        }
    }
    
    private func isCreateEnabled(_ viewStore: ViewStore<TeamFeature.State, TeamFeature.Action>) -> Bool {
        let isEnabled = viewStore.isTeamNameValid &&
        viewStore.isDuplicateChecked &&
        !viewStore.showTeamNameError &&
        viewStore.selectedManagerRange != nil &&
        !viewStore.membershipFee.isEmpty &&
        viewStore.teamLogoImage != nil
        
        return isEnabled
    }
}
