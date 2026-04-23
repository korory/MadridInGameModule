//
//  SeeReservationsOrCreateTeamTrainingComponentView.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 15/10/24.
//

import SwiftUI

struct SeeReservationsOrCreateTeamTrainingComponentView: View {
    @ObservedObject var viewModel: SeeReservationsOrCreateTeamTrainingViewModel
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.black, Color.white.opacity(0.15)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(.all)
            
            if viewModel.showToastDeleteSuccess {
                ToastMessage(message: "Reserva Eliminada".localized, duration: 2, success: true) {
                    self.viewModel.showToastDeleteSuccess = false
                }
                .zIndex(1)
            } else if viewModel.showToastDeleteFailure {
                ToastMessage(message: "Problema al eliminar una reserva".localized, duration: 2, success: false) {
                    self.viewModel.showToastDeleteFailure = false
                }
                .zIndex(1)
            } else if viewModel.showLegendPopup {
                CustomPopup(isPresented: $viewModel.showLegendPopup) {
                    ColorLegendView()
                }
                .transition(.scale)
                .zIndex(1)
            }
            
            if viewModel.isLoading {
                LoadingView(message: "Preparando tu calendario...".localized)
                
            } else {
                VStack (alignment: .leading) {
                    calendarComponent
                    nextTrainingBanner
                    if viewModel.isTrainingsVisible {
                        ScrollView {
                            if !viewModel.isUserMode {
                                trainingTeamList
                            } else {
                                trainingTeamList
                            }
                        }
                    }
                    Spacer()
                }
                .padding(.leading, 10)
                .padding(.trailing, 10)
                .sheet(item: $viewModel.teamSelectedInformation) { reservation in
                    ReservationCardComponent(viewModel: ReservationCardViewModel(reservation: reservation))
                        .zIndex(1)
                }
                .sheet(item: $viewModel.individualSelectedInformation) { reservation in
                    ReservationIndividualCardComponent(viewModel: ReservationIndividualCardViewModel(reservation: reservation))
                        .zIndex(1)
                }
            }
        }
    }
}

extension SeeReservationsOrCreateTeamTrainingComponentView {
    private var calendarComponent: some View {
        VStack (alignment: .center){
            HStack {
                if !viewModel.isUserMode {
                    loadTeamImage
                }
                TextWithUnderlineComponent(title: "dashboard.sections.calendar".localized, underlineColor: Color.cyan)
                    .padding(.top, viewModel.isUserMode ? 10 : 0)
                    .padding(.leading, viewModel.isUserMode ? 5 : 0)
                Spacer()
                Button {
                    self.viewModel.showLegendPopup.toggle()
                } label: {
                    Text("legend".localized)
                }
                .padding(.trailing, 10)
                Image(systemName: "arrowtriangle.down.fill")
                    .rotationEffect(.degrees(viewModel.calendarArrowRotation))
                    .animation(.easeInOut, value: viewModel.calendarArrowRotation)
                    .foregroundColor(.cyan)
            }
            //.padding(.top, 5)
            .padding(.bottom, 5)
            .onTapGesture {
                withAnimation {
                    viewModel.isCalendarVisible.toggle()
                    viewModel.calendarArrowRotation += 180
                }
            }
            if viewModel.isCalendarVisible {
                CustomCalendarView(canUserInteract: false, markedDates: viewModel.markedDates) { stringDate in
                    viewModel.dateSelected = stringDate
                    viewModel.isDateSelected = true
                }
                .frame(minHeight: 280, maxHeight: 360)
                .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
    
    private var nextTrainingBanner: some View {
        VStack {
            HStack (spacing: 8){
                TextWithUnderlineComponent(title: viewModel.isDateSelected ? "dashboard.layout.trainings".localized : "dashboard.teams.teamAreas.training.upcoming".localized, underlineColor: Color.cyan)
                    .padding(.top, viewModel.isUserMode ? 10 : 0)
                    .padding(.leading, viewModel.isUserMode ? 5 : 0)
                
                Spacer ()
                
                Image(systemName: "arrowtriangle.down.fill")
                    .rotationEffect(.degrees(viewModel.trainingArrowRotation))
                    .animation(.easeInOut, value: viewModel.trainingArrowRotation)
                    .foregroundColor(.cyan)
                
            }
            .padding(.top, 20)
            .padding(.bottom, 20)
            .onTapGesture {
                withAnimation {
                    viewModel.isTrainingsVisible.toggle()
                    viewModel.trainingArrowRotation += 180
                }
            }
        }
    }
    
    private var trainingTeamList: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            if !viewModel.allIndividualReservations.isEmpty {
                Text("Reservas Individuales".localized)
                    .font(.madridInGameiOSFont(size: 13))
                    .foregroundColor(.white)
                    .opacity(0.7)
                    .padding(.leading, 2)
                
                ForEach(viewModel.allIndividualReservations, id: \.id) { individualReservation in
                    IndividualReservationsCellComponent(viewModel: IndividualReservationsCellViewModel(reservation: individualReservation, showDeleteAndEditOption: false)) { optionSelected in
                        viewModel.trainingIndividualListCellPressed(individualSelectedInformation: individualReservation, optionSelected: optionSelected)
                    }
                }
            }
            
            if !viewModel.allReservations.isEmpty {
                Text("Reservas De Equipo".localized)
                    .font(.madridInGameiOSFont(size: 13))
                    .foregroundColor(.white)
                    .opacity(0.7)
                
                ForEach(viewModel.allReservations, id: \.id) { reservation in
                    TeamReservationCellComponentView(viewModel: TeamReservationCellComponentViewModel(reservation: reservation, showDeleteAndEditOption: false)) { optionSelected in
                        viewModel.trainingTeamListCellPressed(teamSelectedInformation: reservation, optionSelected: optionSelected)
                    }
                }
            }
            
            
            if viewModel.allIndividualReservations.isEmpty && viewModel.allReservations.isEmpty {
                Text("dashboard.teams.teamAreas.trainings.noTrainings".localized)
                    .font(.madridInGameiOSFont(size: 14))
                    .foregroundColor(.white)
                    .opacity(0.7)
                    .padding()
            }
        }
        .padding(5)
    }
    
    private var loadTeamImage: some View {
        let environmentManager = EnvironmentManager()
        
        return AnyView(
            AsyncImage(url: URL(string: "\(environmentManager.getBaseURL())/assets/\(viewModel.getTeamPicture())")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.purple))
                        .frame(width: 10, height: 10)
                        .padding(.leading, 5)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 48, height: 48)
                        .clipShape(Circle())
                        .padding(.leading, 5)
                case .failure:
                    Image(systemName: "person.2.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .padding(.leading, 5)
                @unknown default:
                    EmptyView()
                }
            }
        )
    }
}
