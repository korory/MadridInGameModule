//
//  MadridInGameViewModel.swift
//  Pods
//
//  Created by Arnau Rivas Rivas on 4/2/25.
//

import SwiftUI
import FontBlaster

public struct MadridInGameUserData {
    let name: String?
    let lastName: String?
    let userName: String
    let email: String
    let dni: String?
    let phone: String?
    let accessToken: String
    let logoMIG: UIImage?
    let qrMiddleLogo: UIImage?
    
    public init(name: String? = nil, lastName: String? = nil, userName: String, email: String, dni: String? = nil, phone: String? = nil, accessToken: String, logoMIG: UIImage? = nil, qrMiddleLogo: UIImage? = nil) {
        self.name = name
        self.lastName = lastName
        self.userName = userName
        self.email = email
        self.dni = dni
        self.phone = phone
        self.accessToken = accessToken
        self.logoMIG = logoMIG
        self.qrMiddleLogo = qrMiddleLogo
    }
}

class MadridInGameiOSViewModel: ObservableObject {
    @Published var selectedTab: Int = 0
    @Published var isLoading: Bool = true
    @Published var user: UserModel?
    @Published var errorMessage: String?
    @Published var openCompetitions: Bool
    
    private let userInfo: MadridInGameUserData

    private let userManager = UserManager.shared
    private let environmentManager: EnvironmentManager
    
    private var originalStyle: UIUserInterfaceStyle?
    
    init(userInfo: MadridInGameUserData, isPro: Bool, openCompetitions: Bool) {
        self.userInfo = userInfo
        self.environmentManager = EnvironmentManager(isPro: isPro)
        self.openCompetitions = openCompetitions
        
        Logger.shared.isEnabled = !isPro
        if self.openCompetitions {
            self.selectTab(2)
        }
        
        Task.detached { [envManager = self.environmentManager] in
            await DirectusService.shared.configure(with: envManager)
        }
        FontManager().loadCustomFonts()
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = windowScene.windows.first {
                self.originalStyle = window.overrideUserInterfaceStyle
                window.overrideUserInterfaceStyle = .dark
            }
        }
    }
    
    func initializeModule() {
        userManager.initializeUser(userInfo: userInfo) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success:
                    self.user = self.userManager.getUser()
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
                self.isLoading = false
            }
        }
    }
    
    func selectTab(_ tab: Int) {
        selectedTab = tab
        if tab == 0 || tab == 1 {
            initializeModule()
        }
    }
    
    func getUserTeams() -> [TeamModelReal] {
        return userManager.getUser()?.teamsResponse ?? []
    }
    
    func onDisappear() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = windowScene.windows.first {
                window.overrideUserInterfaceStyle = self.originalStyle ?? .dark
            }
        }
    }
    
//    func loadCustomFonts() {
//        guard let fontURL = Bundle.frameworkBundle?.url(forResource: "Madrid_in_game_font", withExtension: "otf") else {
//            Logger.shared.log("Fuente no encontrada")
//            return
//        }
//        
//        do {
//            try FontBlaster.blast(fonts: [fontURL])
//            Logger.shared.log("Fuente cargada correctamente")
//        } catch {
//            Logger.shared.log("Error al cargar la fuente: \(error)")
//        }
//    }

}
