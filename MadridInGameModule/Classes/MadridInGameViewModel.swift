//
//  MadridInGameViewModel.swift
//  Pods
//
//  Created by Arnau Rivas Rivas on 4/2/25.
//

import SwiftUI
import FontBlaster

class MadridInGameViewModel: ObservableObject {
    @Published var selectedTab: Int = 0
    @Published var isLoading: Bool = true
    @Published var user: UserModel?
    @Published var errorMessage: String?
    @Published var openCompetitions: Bool

    private let email: String
    private let userManager = UserManager.shared
    private let environmentManager: EnvironmentManager
    
    init(email: String, isPro: Bool, openCompetitions: Bool) {
        self.email = email
        self.environmentManager = EnvironmentManager(isPro: isPro)
        self.openCompetitions = openCompetitions
        
        if self.openCompetitions {
            self.selectTab(2)
        }
        
        Task.detached { [envManager = self.environmentManager] in
            await DirectusService.shared.configure(with: envManager)
        }
        FontManager().loadCustomFonts()
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = windowScene.windows.first {
                window.overrideUserInterfaceStyle = .dark
            }
        }
    }
    
    func initializeModule() {
        //isLoading = true
        userManager.initializeUser(withEmail: email) { [weak self] result in
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
    
//    func loadCustomFonts() {
//        guard let fontURL = Bundle.frameworkBundle?.url(forResource: "Madrid_in_game_font", withExtension: "otf") else {
//            print("Fuente no encontrada")
//            return
//        }
//        
//        do {
//            try FontBlaster.blast(fonts: [fontURL])
//            print("Fuente cargada correctamente")
//        } catch {
//            print("Error al cargar la fuente: \(error)")
//        }
//    }

}
