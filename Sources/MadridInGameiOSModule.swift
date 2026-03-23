//// The Swift Programming Language
//// https://docs.swift.org/swift-book

import SwiftUI

public struct MadridInGameiOSModule: View {
    @StateObject private var viewModel: MadridInGameiOSViewModel
    @Environment(\.presentationMode) var presentationMode
    
    public init(_ model: MadridInGameUserData, isPreRelease: Bool = false) {
        UserDefaults.saveAccessTokenKey(model.accessToken)
        if let logo = model.logoMIG {
            UserDefaults.saveLogoMIG(logo)
        }
        if let logo = model.qrMiddleLogo {
            UserDefaults.saveQrMiddleLogo(logo)
        }
        
        _viewModel = StateObject(wrappedValue: MadridInGameiOSViewModel(userInfo: model, isPro: !isPreRelease, openCompetitions: false))
    }

    public init(email: String, userName: String, dni: String? = nil, accessToken: String, logoMIG: UIImage?, qrMiddleLogo: UIImage?, isPreRelease: Bool = false) {
        UserDefaults.saveAccessTokenKey(accessToken)

        if let logo = logoMIG {
            UserDefaults.saveLogoMIG(logo)
        }
        if let logo = qrMiddleLogo {
            UserDefaults.saveQrMiddleLogo(logo)
        }

        let userInfo = MadridInGameUserData(name: nil, lastName: nil, userName: userName, email: email, dni: dni, phone: nil, accessToken: accessToken, logoMIG: logoMIG, qrMiddleLogo: qrMiddleLogo)
        
        _viewModel = StateObject(wrappedValue: MadridInGameiOSViewModel(userInfo: userInfo, isPro: !isPreRelease, openCompetitions: false))
    }
    
    public var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.black, Color.black, Color.black.opacity(0.9)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(.all)
            
            if viewModel.isLoading {
                LoadingView(message: "Preparando tu experiencia...".localized)
            } else if let errorMessage = viewModel.errorMessage {
                errorView(errorMessage)
            } else if let user = viewModel.user {
                contentView(user: user)
            }
        }
        .onAppear {
            viewModel.initializeModule()
        }
        .onDisappear {
            viewModel.onDisappear()
        }
    }
    
    private func errorView(_ message: String) -> some View {
        VStack {
            Text("Error al cargar el módulo".localized)
                .foregroundColor(.red)
            Text(message)
                .foregroundColor(.white)
        }
        .padding()
    }
    
    private func contentView(user: UserModel) -> some View {
        VStack {
            topBarView
        }
    }
    
    private var topBarView: some View {
        VStack {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 18)
                        .foregroundStyle(.white)
                }
                .padding(.trailing, 10)
                
                tabButton(title: "Dashboard".localized, tab: 0)
                if !viewModel.getUserTeams().isEmpty {
                    tabButton(title: "Equipos".localized, tab: 1)
                }
                tabButton(title: "Competiciones".localized, tab: 2)
            }
            .padding(.horizontal, 10)
            
            if viewModel.selectedTab == 0 {
                DashboardScreenView()
            } else if viewModel.selectedTab == 1 {
                TeamsScreenView()
            } else {
                NavigationView {
                    CompetitionsView(viewModel: CompetitionsViewModel())
                }
            }
        }
    }
    
    private func tabButton(title: String, tab: Int) -> some View {
        Button(action: { viewModel.selectTab(tab) }) {
            VStack {
                Text(title)
                    .foregroundColor(viewModel.selectedTab == tab ? .cyan : .white)
                    .font(.madridInGameiOSFont(size: 15))
                Rectangle()
                    .fill(viewModel.selectedTab == tab ? Color.cyan : Color.clear)
                    .frame(height: 3)
            }
        }
    }
}
