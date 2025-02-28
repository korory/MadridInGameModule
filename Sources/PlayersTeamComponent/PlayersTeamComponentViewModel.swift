//
//  PlayersTeamComponentViewModel.swift
//  Pods
//
//  Created by Hamza El Hamdaoui on 27/1/25.
//

import SwiftUI

class PlayersTeamComponentViewModel: ObservableObject {
    @Published var userManager = UserManager.shared
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

//    init() {
//        self.getAllPlayersWithTeamSelected()
//    }
    
    func getAllPlayersWithTeamSelected() -> [TeamUser] {
        return userManager.getSelectedTeam()?.users ?? []
    }
}
