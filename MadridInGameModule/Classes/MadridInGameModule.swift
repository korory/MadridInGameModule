//// The Swift Programming Language
//// https://docs.swift.org/swift-book
//
import SwiftUI

public struct MadridInGameModule: View {
    @State private var selectedTab = 0
    
    public init() {}
    
    public var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea(edges: .all)
            //VStack {
                topBarView
            //}
        }
    }
}

extension MadridInGameModule {
    private var topBarView: some View {
        VStack {
            HStack {
                Button(action: {
                    selectedTab = 0
                }) {
                    VStack {
                        Text("Dashboard")
                            .foregroundColor(selectedTab == 0 ? .cyan : .white)
                            .frame(maxWidth: .infinity)
                        
                        Rectangle()
                            .fill(selectedTab == 0 ? Color.cyan : Color.clear)
                            .frame(height: 3)
                    }
                }
                
                Button(action: {
                    selectedTab = 1
                }) {
                    VStack {
                        Text("Equipos")
                            .foregroundColor(selectedTab == 1 ? .cyan : .white)
                            .frame(maxWidth: .infinity)
                        
                        Rectangle()
                            .fill(selectedTab == 1 ? Color.cyan : Color.clear)
                            .frame(height: 3)
                    }
                }
                Button(action: {
                    selectedTab = 2
                }) {
                    VStack {
                        Text("Competiciones")
                            .foregroundColor(selectedTab == 2 ? .cyan : .white)
                            .frame(maxWidth: .infinity)
                        
                        Rectangle()
                            .fill(selectedTab == 2 ? Color.cyan : Color.clear)
                            .frame(height: 3)
                    }
                }
            }
            .padding(.leading, 10)
            .padding(.trailing, 10)
            if selectedTab == 0 {
                DashboardScreenView()
            } else if selectedTab == 1 {
                TeamsScreenView()
            } else {
                NavigationView {
                    CompetitionsView(viewModel: CompetitionsViewModel(competitionsInformation: mockCompetitions))
                }
            }
        }
    }
}

//NavigationView {
//            ScrollView {
//                VStack {
//                    Text("Dashboard")
//                        .font(.largeTitle)
//
//                    // Botón para abrir ReservationComponentView
//                    NavigationLink(destination: ReservationComponentView()) {
//                        Text("Abrir Reserva")
//                            .padding()
//                            .background(Color.blue)
//                            .foregroundColor(.white)
//                            .cornerRadius(8)
//                    }
//                    .padding()
//
//                    // Botón para abrir otra pantalla
//                    NavigationLink(destination: ProfileInformationComponentView()) {
//                        Text("Profile Info")
//                            .padding()
//                            .background(Color.green)
//                            .foregroundColor(.white)
//                            .cornerRadius(8)
//                    }
//                    .padding()
//
//                    // Botón para abrir otra pantalla
//                    NavigationLink(destination: TeamsComponentView(viewModel: TeamsComponentViewModel(isUserMode: true, allTeams: mockAllTeams))) {
//                        Text("Teams Component (User)")
//                            .padding()
//                            .background(Color.red)
//                            .foregroundColor(.white)
//                            .cornerRadius(8)
//                    }
//                    .padding()
//
//                    // Botón para abrir otra pantalla
//                    NavigationLink(destination: IndividualReservationsComponentView(viewModel: IndividualReservationComponentViewModel(reservationModel: mockIndividualReservation))) {
//                        Text("Individual Reservation Component")
//                            .padding()
//                            .background(Color.gray)
//                            .foregroundColor(.white)
//                            .cornerRadius(8)
//                    }
//                    .padding()
//
//                    Text("Equipos")
//                        .font(.largeTitle)
//
//                    // Botón para abrir otra pantalla
//                    NavigationLink(destination: SeeReservationsOrCreateTeamTrainingComponentView(viewModel: SeeReservationsOrCreateTeamTrainingViewModel(isUserMode: true, markedDates: [
//                        Calendar.current.date(from: DateComponents(year: 2024, month: 10, day: 17))!,
//                        Calendar.current.date(from: DateComponents(year: 2024, month: 10, day: 20))!
//                    ]))) {
//                        Text("Create Or See Reservations (User)")
//                            .padding()
//                            .background(Color.purple)
//                            .foregroundColor(.white)
//                            .cornerRadius(8)
//                    }
//                    .padding()
//
//                    // Botón para abrir otra pantalla
//                    NavigationLink(destination: SeeReservationsOrCreateTeamTrainingComponentView(viewModel: SeeReservationsOrCreateTeamTrainingViewModel(isUserMode: false, markedDates: [
//                        Calendar.current.date(from: DateComponents(year: 2024, month: 10, day: 17))!
//                    ]))) {
//                        Text("Create Or See Reservations (Team)")
//                            .padding()
//                            .background(Color.purple)
//                            .foregroundColor(.white)
//                            .cornerRadius(8)
//                    }
//                    .padding()
//
//                    // Botón para abrir otra pantalla
//                    NavigationLink(destination:
//                                    PlayersTeamComponentView(teamSelected: mockTeamPapaFrita)
//                    ) {
//                        Text("List Of Players")
//                            .padding()
//                            .background(Color.orange)
//                            .foregroundColor(.white)
//                            .cornerRadius(8)
//                    }
//                    .padding()
//
//                    // Botón para abrir otra pantalla
//                    NavigationLink(destination:
//                        NewsComponentView(viewModel: NewsViewModel(allNews: mockAllNews))
//                    ) {
//                        Text("Create New News")
//                            .padding()
//                            .background(Color.orange)
//                            .foregroundColor(.white)
//                            .cornerRadius(8)
//                    }
//                    .padding()
//
//                    // Botón para abrir otra pantalla
//                    NavigationLink(destination: TeamsComponentView(viewModel: TeamsComponentViewModel(isUserMode: false, allTeams: [mockTeamSamsung]))) {
//                        Text("Teams Component (Team)")
//                            .padding()
//                            .background(Color.red)
//                            .foregroundColor(.white)
//                            .cornerRadius(8)
//                    }
//                    .padding()
//
//                    Text("Commom")
//                        .font(.largeTitle)
//
//                    // Botón para abrir otra pantalla
//                    NavigationLink(destination: CardDetailNewsView(news: mockAllNews.first!)) {
//                        Text("News Detail Screen")
//                            .padding()
//                            .background(Color.yellow)
//                            .foregroundColor(.white)
//                            .cornerRadius(8)
//                    }
//                    .padding()
//
//
//                    // Botón para abrir otra pantalla
//                    NavigationLink(destination: CompetitionsView(viewModel: CompetitionsViewModel(competitionsInformation: mockCompetitions))) {
//                        Text("Competitions")
//                            .padding()
//                            .background(Color.green)
//                            .foregroundColor(.white)
//                            .cornerRadius(8)
//                    }
//                    .padding()
//                }
//            }
//        }
//    }


struct MadridInGameModule_Previews: PreviewProvider {
    static var previews: some View {
        MadridInGameModule()
    }
}


#Preview {
    MadridInGameModule()
}
