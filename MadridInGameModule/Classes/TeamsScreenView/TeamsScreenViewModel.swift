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
    @Published var selectedTeam: TeamModelReal?

    init() {
        optionTabSelected = .trainning
    }
    
    func getAllTeams() -> [TeamModelReal] {
        return userManager.getUser()?.teams ?? []
    }
    
    func setTeamSelected(team: TeamModelReal) {
        self.selectedTeam = team
        self.teamSelected = true
    }
    
    func getTeamSelected() -> TeamModelReal {
        return self.selectedTeam!//userManager.getUser()?.selectedTeam
    }
}
