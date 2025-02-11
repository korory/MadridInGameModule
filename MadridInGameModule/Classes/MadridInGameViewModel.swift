//
//  MadridInGameViewModel.swift
//  Pods
//
//  Created by Arnau Rivas Rivas on 4/2/25.
//

import SwiftUI

class MadridInGameViewModel: ObservableObject {
    @Published var selectedTab: Int = 0
    @Published var isLoading: Bool = true
    @Published var user: UserModel?
    @Published var errorMessage: String?
    
    private let email: String
    private let userManager = UserManager.shared
    private let environmentManager: EnvironmentManager
    
    init(email: String, environment: String) {
        self.email = email
        self.environmentManager = EnvironmentManager(environment: environment)
        
        Task.detached { [envManager = self.environmentManager] in
            await DirectusService.shared.configure(with: envManager)
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
        return userManager.getUser()?.teams ?? []
    }
}
