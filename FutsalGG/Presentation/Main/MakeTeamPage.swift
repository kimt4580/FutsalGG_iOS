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
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                VStack {
                    DepthHeader(title: "팀 생성하기")
                    
                    if let makeTeamState = viewStore.makeTeam {
                        ScrollView {
                            teamInfoSection(viewStore: viewStore, makeTeamState: makeTeamState)
                        }
                        .simultaneousGesture(
                            TapGesture().onEnded {
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            }
                        )
                        createTeamButton(viewStore: viewStore, makeTeamState: makeTeamState)
                    }
                }
                
                if viewStore.showLoading {
                    loadingView(viewStore: viewStore)
                }
                
                if let makeTeamState = viewStore.makeTeam, makeTeamState.makeTeamSuccess {
                    successModal(viewStore: viewStore, makeTeamState: makeTeamState)
                }
            }
            .onAppear {
                if viewStore.makeTeam == nil {
                    viewStore.send(.resetMakeTeam)
                }
            }
            .navigationBarBackButtonHidden()
            .navigationDestination(isPresented: $showImageEditor) {
                ImageEditorView(selectedImage: $selectedImage)
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $selectedImage, isShown: $showImagePicker) { image in
                    selectedImage = image
                    viewStore.send(.makeTeam(.setTeamLogoImage(image)))
                    showImagePicker = false
                    showImageEditor = true
                }
            }
            .onAppear {
                viewStore.send(.resetMakeTeam)
            }
        }
    }
    
    @ViewBuilder
    private func teamInfoSection(viewStore: ViewStore<TeamFeature.State, TeamFeature.Action>, makeTeamState: MakeTeamFeature.State) -> some View {
        VStack {
            // Required mark
            HStack {
                Spacer()
                Text("*필수")
                    .pretendardStyle(.B_17_200)
                    .foregroundStyle(.mint500)
            }
            .padding(.vertical, 16)
            
            // Team name section
            teamNameSection(viewStore: viewStore, makeTeamState: makeTeamState)
                .padding(.top, 8)
            
            // Team introduction section
            teamIntroductionSection(viewStore: viewStore, makeTeamState: makeTeamState)
                .padding(.top, 56)
            
            // Team rule section
            teamRuleSection(viewStore: viewStore, makeTeamState: makeTeamState)
                .padding(.top, 56)
            
            // Manager range section
            managerRangeSection(viewStore: viewStore, makeTeamState: makeTeamState)
                .padding(.top, 56)
            
            // Membership fee section
            membershipFeeSection(viewStore: viewStore, makeTeamState: makeTeamState)
                .padding(.top, 56)
            
            // Team logo section
            teamLogoSection(viewStore: viewStore, makeTeamState: makeTeamState)
                .padding(.top, 56)
                .padding(.bottom, 57)
        }
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    private func teamNameSection(viewStore: ViewStore<TeamFeature.State, TeamFeature.Action>, makeTeamState: MakeTeamFeature.State) -> some View {
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
                    get: { _ in makeTeamState.teamName },
                    send: { .makeTeam(.setTeamName($0)) }
                ))
                .onChange(of: makeTeamState.teamName) { oldValue, newValue in
                    if !newValue.isEmpty {
                        viewStore.send(.makeTeam(.validateTeamName))
                    }
                }
                .foregroundStyle(.mono900)
                .pretendardStyle(.R_17_200)
                .padding(.leading, 17)
                .frame(height: 48)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(strokeColor(makeTeamState))
                )
                
                Button {
                    if makeTeamState.isTeamNameValid {
                        viewStore.send(.makeTeam(.checkTeamNameDuplicate))
                    }
                } label: {
                    Text("중복확인")
                        .foregroundStyle(makeTeamState.teamName.isEmpty || !makeTeamState.isTeamNameValid ? .mono500 : .white)
                        .pretendardStyle(.B_17_200)
                        .frame(width: 78, height: 48)
                }
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(makeTeamState.teamName.isEmpty || !makeTeamState.isTeamNameValid ? .mono200 : .mono900)
                )
                .disabled(makeTeamState.teamName.isEmpty || !makeTeamState.isTeamNameValid)
            }
            
            if makeTeamState.showTeamNameError {
                HStack {
                    Text(makeTeamState.teamNameErrorMessage)
                        .pretendardStyle(.R_17_200)
                        .foregroundStyle(.pointOrange)
                    Spacer()
                }
            } else if makeTeamState.isDuplicateChecked {
                HStack {
                    Text(makeTeamState.teamNameSuccessMessage)
                        .pretendardStyle(.R_17_200)
                        .foregroundStyle(.mint500)
                    Spacer()
                }
            }
        }
    }
    
    @ViewBuilder
    private func teamIntroductionSection(viewStore: ViewStore<TeamFeature.State, TeamFeature.Action>, makeTeamState: MakeTeamFeature.State) -> some View {
        VStack {
            HStack {
                Text("팀 소개")
                    .pretendardStyle(.B_20_300)
                    .foregroundStyle(.mono900)
                Spacer()
            }
            
            TextField("팀의 소개를 작성해주세요 (20자 이내)", text: viewStore.binding(
                get: { _ in makeTeamState.teamDescription },
                send: { .makeTeam(.setTeamDescription($0)) }
            ))
            .foregroundStyle(.mono900)
            .frame(height: 80)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.mono200)
            )
        }
    }
    
    @ViewBuilder
    private func teamRuleSection(viewStore: ViewStore<TeamFeature.State, TeamFeature.Action>, makeTeamState: MakeTeamFeature.State) -> some View {
        VStack {
            HStack {
                Text("팀 규칙")
                    .pretendardStyle(.B_20_300)
                    .foregroundStyle(.mono900)
                Spacer()
            }
            
            TextField("팀의 규칙을 작성해주세요. (일정, 회비, 계좌번호 등)", text: viewStore.binding(
                get: { _ in makeTeamState.teamRule },
                send: { .makeTeam(.setTeamRules($0)) }
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
    }
    
    @ViewBuilder
    private func managerRangeSection(viewStore: ViewStore<TeamFeature.State, TeamFeature.Action>, makeTeamState: MakeTeamFeature.State) -> some View {
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
                viewStore.send(.makeTeam(.toggleDropdown(.managerRange)))
            } label: {
                HStack {
                    Text(makeTeamState.selectedManagerRange?.rawValue ?? "선택하기")
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
            
            if makeTeamState.showDropdown == .managerRange {
                VStack(spacing: 0) {
                    ForEach(MakeTeamFeature.State.ManagerRange.allCases, id: \.self) { range in
                        Button {
                            viewStore.send(.makeTeam(.setManagerRange(range)))
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
                            .background(makeTeamState.selectedManagerRange == range ? Color.mint100 : .clear)
                        }
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.mono200)
                )
            }
        }
    }
    
    @ViewBuilder
    private func membershipFeeSection(viewStore: ViewStore<TeamFeature.State, TeamFeature.Action>, makeTeamState: MakeTeamFeature.State) -> some View {
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
                    get: { _ in makeTeamState.membershipFee },
                    send: { .makeTeam(.setMembershipFee($0)) }
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
    }
    
    @ViewBuilder
    private func teamLogoSection(viewStore: ViewStore<TeamFeature.State, TeamFeature.Action>, makeTeamState: MakeTeamFeature.State) -> some View {
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
    }
    
    @ViewBuilder
    private func createTeamButton(viewStore: ViewStore<TeamFeature.State, TeamFeature.Action>, makeTeamState: MakeTeamFeature.State) -> some View {
        VStack {
            Divider()
                .foregroundStyle(.mono200)
                .padding(.bottom, 16)
            
            Button {
                viewStore.send(.makeTeam(.makeTeamButtonTapped))
            } label: {
                Text("생성하기")
                    .foregroundStyle(isCreateEnabled(makeTeamState) ? .white : .mono500)
                    .pretendardStyle(.B_20_300)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
            }
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(isCreateEnabled(makeTeamState) ? .mono900 : .mono200)
            )
            .disabled(!isCreateEnabled(makeTeamState))
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
    }
    
    @ViewBuilder
    private func loadingView(viewStore: ViewStore<TeamFeature.State, TeamFeature.Action>) -> some View {
        LoadingView {
            viewStore.send(.showLoading(false))
            viewStore.send(.makeTeam(.makeTeamSuccess))
        }
    }
    
    @ViewBuilder
    private func successModal(viewStore: ViewStore<TeamFeature.State, TeamFeature.Action>, makeTeamState: MakeTeamFeature.State) -> some View {
        Color.black.opacity(0.7)
            .ignoresSafeArea()
        
        VStack {
            VStack {
                Text("\(makeTeamState.teamName)")
                    .pretendardStyle(.B_20_300)
                    .foregroundStyle(.mono900)
                Text("팀이 생성되었습니다!")
                    .pretendardStyle(.B_20_300)
                    .foregroundStyle(.mono900)
            }
            .padding(.vertical, 16)
            
            Button {
                viewStore.send(.makeTeam(.confirmMakeTeamSuccess))
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
    
    private func strokeColor(_ state: MakeTeamFeature.State) -> Color {
        if state.showTeamNameError {
            return .pointOrange
        } else if state.isDuplicateChecked && !state.showTeamNameError {
            return .mint500
        } else if state.isTeamNameValid {
            return .mono900
        } else {
            return .mono200
        }
    }
    
    private func isCreateEnabled(_ state: MakeTeamFeature.State) -> Bool {
        return state.isTeamNameValid &&
        state.isDuplicateChecked &&
        !state.showTeamNameError &&
        state.selectedManagerRange != nil &&
        !state.membershipFee.isEmpty &&
        state.teamLogoImage != nil
    }
}
