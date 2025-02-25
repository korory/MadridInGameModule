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
        VStack {
            if viewModel.getAllTeams().count >= 2 && !viewModel.teamSelected {
                SelectTeamComponent(allTeams: viewModel.getAllTeams(),
                                    onTeamSelected: { team in
                    //self.viewModel.userManager.setSelectedTeam(team)
                    self.viewModel.setTeamSelected(team: team)
                })
            } else if viewModel.getAllTeams().count == 1 || viewModel.teamSelected {
                tabBarComponent
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
                    
                    NewsComponentView(viewModel: NewsViewModel(allNews: mockAllNews))
                        .tabItem {
                            Label("Noticias", systemImage: "newspaper.circle.fill")
                        }
                        .tag(TabBarTeamsBottom.news)
                    
                    PlayersTeamComponentView(viewModel: PlayersTeamComponentViewModel(user: UserManager.shared.getUser()))
                        .tabItem {
                            Label("Jugadores", systemImage: "person.3.fill")
                        }
                        .tag(TabBarTeamsBottom.team
                        )
                    
//                    TeamsComponentView(viewModel: TeamsComponentViewModel(isUserMode: false, allTeams: []))
//                        .tabItem {
//                            Label("Equipo", systemImage: "person.3.fill")
//                        }
//                        .tag(TabBarTeamsBottom.players)
                        SelectTeamComponent(allTeams: viewModel.getAllTeams(),
                                            onTeamSelected: { team in
                            self.viewModel.setTeamSelected(team: team)
                            self.viewModel.optionTabSelected = .trainning
                            self.viewModel.selectedTab = TabBarTeamsBottom.trainning
                        })
                            .tabItem {
                                Label("Cambio Equipo", systemImage: "arrow.left.arrow.right")
                            }
                            .tag(TabBarTeamsBottom.changeTeam)
                    
                }
                .accentColor(.cyan)
                //.padding(.top)
            } else {
                Text("No hay información disponible.")
                    .foregroundColor(.white)
                    .padding()
            }
        }
    }
}

