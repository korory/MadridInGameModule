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
            if let selectedSplit = viewModel.optionTabSelected {
                TabView(selection: $viewModel.selectedTab) {
                    SeeReservationsOrCreateTeamTrainingComponentView(viewModel: SeeReservationsOrCreateTeamTrainingViewModel(isUserMode: true, markedDates: [
                        Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 17))!,
                        Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 20))!
                    ]))
                        .tabItem {
                            Label("Calendario", systemImage: "calendar")
                        }
                        .tag(TabBarDashboardBottom.calendar)

                    
                    IndividualReservationsComponentView(viewModel: IndividualReservationComponentViewModel(reservationModel: mockIndividualReservation))
                        .tabItem {
                            Label("Reservas", systemImage: "calendar.badge.checkmark")
                        }
                        .tag(TabBarDashboardBottom.reservation)
                    
                    TeamsComponentView(viewModel: TeamsComponentViewModel(isUserMode: true, allTeams: mockAllTeams))
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

//    private var bottomBarView: some View {
//        VStack {
//            HStack {
//                Button(action: {
//                    selectedTab = 0
//                }) {
//                    VStack {
//                        Text("Calendario")
//                            .foregroundColor(selectedTab == 0 ? .blue : .white)
//                            .frame(maxWidth: .infinity)
//
//                        Rectangle()
//                            .fill(selectedTab == 0 ? Color.blue : Color.clear)
//                            .frame(height: 3)
//                    }
//                }
//
//                Button(action: {
//                    selectedTab = 1
//                }) {
//                    VStack {
//                        Text("Equipo")
//                            .foregroundColor(selectedTab == 1 ? .blue : .white)
//                            .frame(maxWidth: .infinity)
//
//                        Rectangle()
//                            .fill(selectedTab == 1 ? Color.blue : Color.clear)
//                            .frame(height: 3)
//                    }
//                }
//            }
//            .padding(.leading, 10)
//            .padding(.trailing, 10)
//            // Contenido dinámico basado en la pestaña seleccionada
//            if selectedTab == 0 {
//                DashboardScreenView()
//            } else {
//                EquipoView()
//            }
//        }
//    }
//}
