//
//  TeamsScreenView.swift
//  MadridInGameModule
//
//  Created by Arnau Rivas Rivas on 6/11/24.
//

import SwiftUI

struct TeamsScreenView: View {
    @StateObject private var viewModel = TeamsScreenViewModel()
    
    var body: some View {
        tabBarComponent
    }
}

extension TeamsScreenView {
    private var tabBarComponent: some View {
        Group {
            if let selectedSplit = viewModel.optionTabSelected {
                TabView(selection: $viewModel.selectedTab) {
                    SeeReservationsOrCreateTeamTrainingComponentView(viewModel: SeeReservationsOrCreateTeamTrainingViewModel(isUserMode: false, markedDates: [
                        Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 17))!,
                        Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 20))!
                    ]))
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
                    
                    TeamsComponentView(viewModel: TeamsComponentViewModel(isUserMode: false, allTeams: []))
                        .tabItem {
                            Label("Equipo", systemImage: "person.3.fill")
                        }
                        .tag(TabBarTeamsBottom.players)
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

