//
//  DashboardScreenView.swift
//  MadridInGameModule
//
//  Created by Arnau Rivas Rivas on 6/11/24.
//

import SwiftUI

struct DashboardScreenView: View {
    @StateObject private var viewModel = DashboardScreenViewModel()
    
    var body: some View {
        tabBarComponent
    }
}

extension DashboardScreenView {
    private var tabBarComponent: some View {
        Group {
            if (viewModel.optionTabSelected != nil) {
                TabView(selection: $viewModel.selectedTab) {
                    SeeReservationsOrCreateTeamTrainingComponentView(viewModel: SeeReservationsOrCreateTeamTrainingViewModel(isUserMode: true, selectedTeam: nil))
                        .tabItem {
                            Label("Calendario", systemImage: "calendar")
                        }
                        .tag(TabBarDashboardBottom.calendar)

                    
                    IndividualReservationsComponentView(viewModel: IndividualReservationComponentViewModel())
                        .tabItem {
                            Label("Reservas", systemImage: "calendar.badge.checkmark")
                        }
                        .tag(TabBarDashboardBottom.reservation)
                    
                    TeamsComponentView(viewModel: TeamsComponentViewModel(isUserMode: true, allTeams: []))
                        .tabItem {
                            Label("Equipos", systemImage: "person.3.fill")
                        }
                        .tag(TabBarDashboardBottom.teams)

                    
                    ProfileInformationComponentView()
                        .tabItem {
                            Label("Sobre Mi", systemImage: "person.circle")
                        }
                        .tag(TabBarDashboardBottom.aboutus)

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
