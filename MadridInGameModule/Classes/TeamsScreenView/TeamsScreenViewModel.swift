//
//  TeamsScreenViewModel.swift
//  MadridInGameModule
//
//  Created by Arnau Rivas Rivas on 6/11/24.
//

import SwiftUI

enum TabBarTeamsBottom: Hashable {
    case trainning
    case news
    case team
    case players
}

class TeamsScreenViewModel: ObservableObject {
    @Published var selectedTab: TabBarTeamsBottom = .trainning
    @Published var optionTabSelected: TabBarTeamsBottom? = .trainning
    @Published var userManager = UserManager.shared
    @Published var teamSelected = false

    init() {
        optionTabSelected = .trainning
    }
    
    func getAllTeams() -> [TeamModelReal] {
        return userManager.getUser()?.teams ?? []
    }
    
    func getTeamSelected() -> TeamModelReal? {
        return userManager.getUser()?.selectedTeam
    }
}
