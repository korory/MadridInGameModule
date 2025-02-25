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
                VStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.purple))
                        .scaleEffect(1.5)
                        .padding()
                    
                    Text("Preparando tu calendario...")
                        .font(.custom("Madridingamefont-Regular", size: 15))
                        .foregroundColor(.white)
                        .opacity(0.7)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
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
                
//                CustomPopup(isPresented: Binding(
//                    get: { viewModel.isEditTraning },
//                    set: { viewModel.isEditTraning = $0 }
//                )) {
//                    //EditTrainingComponentView(reservationModel: viewModel.teamReservationCellInformation)
//                    EmptyView()
//                }
//                .transition(.scale)
//                .zIndex(1)
                
                CustomPopup(isPresented: Binding(
                    get: { viewModel.isRemoveTraning },
                    set: { viewModel.isRemoveTraning = $0 }
                )) {
                    CancelOrDeleteComponent(title: "CANCELAR RESERVA", subtitle: "¿Quieres cancelar este entrenamiento?") {
                        self.viewModel.isRemoveTraning = false
                    } aceptedAction: {
                        self.viewModel.isRemoveTraning = false
                        self.viewModel.deleteReservation()
                        //TODO: Remove this to backend
                    }
                }
                //.transition(.scale)
                .zIndex(1)
                
//                CustomPopup(isPresented: Binding(
//                    get: { viewModel.isCreateNewTraining },
//                    set: { viewModel.isCreateNewTraining = $0 }
//                )) {
//                    CreateNewTrainingView(viewModel: CreateNewTrainingViewModel(dateSelected: viewModel.dateSelected, availableHoursReservation: ["14:00", "15:00", "16:00", "17:00", "18:00", "19:00"], availableConsoleReservation: ["PC", "Xbox", "PlayStation", "Tablet"])) {
//                        self.viewModel.isCreateNewTraining = false
//                    }
//                }
//                .transition(.scale)
//                .zIndex(1)
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
                
//                if (viewModel.isDateSelected){
//                    Button {
//                        self.viewModel.isCreateNewTraining = true
//                    } label: {
//                            Image(systemName: "plus.circle.fill")
//                                .resizable()
//                                .frame(width: 20, height: 20)
//                                .clipShape(Circle())
//                                .foregroundStyle(Color.cyan)
//                    }
//                }
                
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
                    IndividualReservationsCellComponent(viewModel: IndividualReservationsCellViewModel(reservation: individualReservation)) { optionSelected in
                        viewModel.trainingIndividualListCellPressed(individualSelectedInformation: individualReservation, optionSelected: optionSelected)
                    }
                }
            }
            Text("Reservas De Equipo")
                .font(.custom("Madridingamefont-Regular", size: 13))
                .foregroundColor(.white)
                .opacity(0.7)

            ForEach(viewModel.allReservations, id: \.id) { reservation in
                TeamReservationCellComponentView(viewModel: TeamReservationCellComponentViewModel(reservation: reservation
                )) { optionSelected in
                    viewModel.trainingTeamListCellPressed(teamSelectedInformation: reservation, optionSelected: optionSelected)
                }
            }
            
        }
        .padding(5)
    }
}
