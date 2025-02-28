//
//  TeamsComponentViewModel.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 14/10/24.
//


import SwiftUI

class TeamsComponentViewModel: ObservableObject {
    @Published var isUserMode: Bool
    @Published var allTeams: [TeamModel]?
    // Variable to control the presentation of the popup for creating a new team
    @Published var createTeamButtonPressed: Bool = false
    @Published var applyForAdmisionButtonPressed: Bool = false
    @Published var isEditTeamPressed: Bool = false
 
    init(isUserMode: Bool, allTeams: [TeamModel]) {
        self.isUserMode = isUserMode
        self.allTeams = allTeams
    }
    
    func addTeamIntoTeamList(newTeam: TeamModel) {
        self.allTeams?.append(newTeam)
    }
    
    func editInformationTeamExists(updateTeam: TeamModel) {
        if let index = self.allTeams?.firstIndex(where: { $0.id == updateTeam.id }) {
            self.allTeams?[index] = updateTeam
        }
    }
}
