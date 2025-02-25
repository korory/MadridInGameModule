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
                ToastMessage(message: "Reserva Eliminada", duration: 2, success: true) {
                    self.viewModel.showToastDeleteSuccess = false
                }
                .zIndex(1)
            } else if viewModel.showToastDeleteFailure {
                ToastMessage(message: "Problema al eliminar una reserva", duration: 2, success: false) {
                    self.viewModel.showToastDeleteFailure = false
                }
                .zIndex(1)
            }
            
            if viewModel.isLoading {
                LoadingView(message: "Preparando tu calendario...")
                
            } else {
                VStack (alignment: .leading) {
                    calendarComponent
                    nextTrainningBanner
                    if viewModel.isTrainingsVisible {
                        ScrollView {
                            if !viewModel.isUserMode {
                                trainningTeamList
                            } else {
                                trainningTeamList
                            }
                        }
                    }
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
                TextWithUnderlineComponent(title: viewModel.isUserMode ? "Calendario" : "Calendario Entrenamientos", underlineColor: Color.cyan)
                Spacer()
                Image(systemName: "arrowtriangle.down.fill")
                    .rotationEffect(.degrees(viewModel.calendarArrowRotation))
                    .animation(.easeInOut, value: viewModel.calendarArrowRotation)
                    .foregroundColor(.cyan)
            }
            .padding(.top, 5)
            .padding(.bottom, 25)
            .onTapGesture {
                withAnimation {
                    viewModel.isCalendarVisible.toggle()
                    viewModel.calendarArrowRotation += 180
                }
            }
            if viewModel.isCalendarVisible {
                CustomCalendarView(canUserInteract: !viewModel.isUserMode, markedDates: viewModel.markedDates) { stringDate in
                    viewModel.dateSelected = stringDate
                    viewModel.isDateSelected = true
                }
                .frame(height: 270)
            }
        }
    }
    
    private var nextTrainningBanner: some View {
        VStack {
            HStack (spacing: 8){
                TextWithUnderlineComponent(title: viewModel.isDateSelected ? "Entrenamientos" : "Próximos entrenamientos", underlineColor: Color.cyan)
                
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
    
    private var trainningTeamList: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            if !viewModel.allIndividualReservations.isEmpty {
                Text("Reservas Individuales")
                    .font(.custom("Madridingamefont-Regular", size: 13))
                    .foregroundColor(.white)
                    .opacity(0.7)
                
                ForEach(viewModel.allIndividualReservations, id: \.id) { individualReservation in
                    IndividualReservationsCellComponent(viewModel: IndividualReservationsCellViewModel(reservation: individualReservation, showDeleteOption: false)) { optionSelected in
                        viewModel.trainingIndividualListCellPressed(individualSelectedInformation: individualReservation, optionSelected: optionSelected)
                    }
                }
            }
            Text("Reservas De Equipo")
                .font(.custom("Madridingamefont-Regular", size: 13))
                .foregroundColor(.white)
                .opacity(0.7)

            ForEach(viewModel.allReservations, id: \.id) { reservation in
                TeamReservationCellComponentView(viewModel: TeamReservationCellComponentViewModel(reservation: reservation, showDeleteOption: false)) { optionSelected in
                    viewModel.trainingTeamListCellPressed(teamSelectedInformation: reservation, optionSelected: optionSelected)
                }
            }
            
        }
        .padding(5)
    }
}
