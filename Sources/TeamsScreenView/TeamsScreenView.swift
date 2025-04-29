//
//  TeamsScreenView.swift
//  MadridInGameModule
//
//  Created by Arnau Rivas Rivas on 6/11/24.
//

import SwiftUI

struct TeamsScreenView: View {
    @StateObject private var viewModel = TeamsScreenViewModel()
    @State private var changeButtonPressed: Bool = false
    
    var body: some View {
        let teams = viewModel.getAllTeams()

        VStack {
            if teams.count >= 2 && !viewModel.teamSelected {
                SelectTeamComponent(allTeams: teams) { team in
                    viewModel.setTeamSelected(team: team)
                }
            } else if teams.count == 1 || viewModel.teamSelected {
                tabBarComponent
            }
        }
        .onAppear {
            let teams = viewModel.getAllTeams()
            viewModel.ensureTeamSelectedIfOnlyOne()
            if teams.count == 1 && !viewModel.teamSelected {
                viewModel.setTeamSelected(team: teams[0])
            }
        }
    }
}

extension TeamsScreenView {
    private var tabBarComponent: some View {
        Group {
            if (viewModel.optionTabSelected != nil) {
                TabView(selection: $viewModel.selectedTab) {
                    SeeReservationsOrCreateTeamTrainingComponentView(viewModel: SeeReservationsOrCreateTeamTrainingViewModel(isUserMode: false, selectedTeam: viewModel.getTeamSelected()))
                        .tabItem {
                            Label("Entrenamiento", systemImage: "calendar")
                        }
                        .tag(TabBarTeamsBottom.trainning)
                    
                    NewsComponentView()
                        .tabItem {
                            Label("Noticias", systemImage: "newspaper.circle.fill")
                        }
                        .tag(TabBarTeamsBottom.news)
                    
                    PlayersTeamComponentView()
                        .tabItem {
                            Label("Jugadores", systemImage: "person.3.fill")
                        }
                        .tag(TabBarTeamsBottom.team
                        )

                    if viewModel.getAllTeams().count >= 2 {
                        VStack {
                        Text("")
                    }
                        .onAppear(perform: {
                            self.viewModel.resetTeamSelected()
                            self.viewModel.optionTabSelected = .trainning
                            self.viewModel.selectedTab = TabBarTeamsBottom.trainning
                            
                        })
                        .tabItem {
                            Label("Cambio Equipo", systemImage: "arrow.left.arrow.right")
                        }
                        .tag(TabBarTeamsBottom.changeTeam)
                }
                }
                .accentColor(.cyan)
                
            } else {
                Text("No hay información disponible.")
                    .foregroundColor(.white)
                    .padding()
            }
        }
    }
}

