//
//  SeeReservationsOrCreateTeamTrainingComponentView.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 15/10/24.
//

import SwiftUI

struct SeeReservationsOrCreateTeamTrainingComponentView: View {
    @ObservedObject var viewModel: SeeReservationsOrCreateTeamTrainingViewModel
    @State private var isCalendarVisible: Bool = true
    @State private var isTrainingsVisible: Bool = true
    @State private var calendarArrowRotation: Double = 0
    @State private var trainingArrowRotation: Double = 0
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea(edges: .all)
            VStack (alignment: .leading) {
                calendarComponent
                nextTrainningBanner
                if isTrainingsVisible {
                    ScrollView {
                        if !viewModel.isUserMode {
                            trainningTeamList
                        } else {
                            trainningIndividualList
                        }
                    }
                }
            }
            .padding(.leading, 10)
            .padding(.trailing, 10)
            
            CustomPopup(isPresented: Binding(
                get: { viewModel.isEditTraning },
                set: { viewModel.isEditTraning = $0 }
            )) {
                EditTrainingComponentView(reservationModel: viewModel.teamReservationCellInformation)
            }
            .transition(.scale)
            .zIndex(1)
            
            CustomPopup(isPresented: Binding(
                get: { viewModel.isRemoveTraning },
                set: { viewModel.isRemoveTraning = $0 }
            )) {
                CancelOrDeleteComponent(title: "CANCELAR RESERVA", subtitle: "¿Quieres cancelar este entrenamiento?") {
                    self.viewModel.isRemoveTraning = false
                } aceptedAction: {
                    self.viewModel.isRemoveTraning = false
                    //TODO: Remove this to backend
                }
            }
            .transition(.scale)
            .zIndex(1)
            
            CustomPopup(isPresented: Binding(
                get: { viewModel.isCreateNewTraining },
                set: { viewModel.isCreateNewTraining = $0 }
            )) {
                CreateNewTrainingView(viewModel: CreateNewTrainingViewModel(dateSelected: viewModel.dateSelected, availableHoursReservation: ["14:00", "15:00", "16:00", "17:00", "18:00", "19:00"], availableConsoleReservation: ["PC", "Xbox", "PlayStation", "Tablet"])) {
                    self.viewModel.isCreateNewTraining = false
                }
            }
            .transition(.scale)
            .zIndex(1)
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
                    .rotationEffect(.degrees(calendarArrowRotation))
                    .animation(.easeInOut, value: calendarArrowRotation)  // Animación suave para la rotación
                    .foregroundColor(.cyan)
            }
            .padding(.top, 5)
            .padding(.bottom, 25)
            .onTapGesture {
                withAnimation {
                    isCalendarVisible.toggle()
                    calendarArrowRotation += 180  // Cambia la rotación de la flecha al alternar visibilidad
                }
            }
            if isCalendarVisible {
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
                
                if (viewModel.isDateSelected){
                    Button {
                        self.viewModel.isCreateNewTraining = true
                    } label: {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .clipShape(Circle())
                                .foregroundStyle(Color.cyan)
                    }
                }
                
                Spacer ()
                
                Image(systemName: "arrowtriangle.down.fill")
                    .rotationEffect(.degrees(trainingArrowRotation))
                    .animation(.easeInOut, value: trainingArrowRotation)  // Animación suave para la rotación
                    .foregroundColor(.cyan)
                
            }
            .padding(.top, 20)
            .padding(.bottom, 20)
            .onTapGesture {
                withAnimation {
                    isTrainingsVisible.toggle()
                    trainingArrowRotation += 180  // Cambia la rotación de la flecha de entrenamientos
                }
            }
        }
    }
    
    private var trainningTeamList: some View {
        VStack(spacing: 20) {
            ForEach(mockTeamReservationCellViewModel, id: \.id) { reservation in
                TeamReservationCellComponentView(viewModel: TeamReservationCellComponentViewModel(trainingLocation: reservation.trainingLocation, dateSelected: reservation.dateSelected, hoursSelected: reservation.hoursSelected, playersAsigned: reservation.playersAsigned, descriptionText: reservation.descriptionText)) { optionSelected in
                    viewModel.trainingTeamListCellPressed(teamSelectedInformation: reservation, optionSelected: optionSelected)
                }
            }
        }
    }
    
    private var trainningIndividualList: some View {
        VStack(spacing: 20) {
            ForEach(mockIndividualReservationCellViewModel, id: \.id) { reservation in
                IndividualReservationCellComponent(viewModel: IndividualReservationCellComponentViewModel(trainingLocation: reservation.trainingLocation, teamAssigned: reservation.teamAssign, dateSelected: reservation.dateSelected, hourSelected: reservation.hoursSelected))
            }
        }
    }
}


//
//import SwiftUI
//
//struct SeeReservationsOrCreateTeamTrainingComponentView: View {
//    @ObservedObject var viewModel: SeeReservationsOrCreateTeamTrainingViewModel
//    
//    var body: some View {
//        ZStack {
//            Color.black
//                .ignoresSafeArea(edges: .all)
//            VStack (alignment: .leading){
////                if !viewModel.isUserMode {
////                    titleBanner
////                }
//                calendarComponent
//                nextTrainningBanner
//                ScrollView {
//                    if !viewModel.isUserMode {
//                        trainningTeamList
//                    } else {
//                        trainningIndividualList
//                    }
//                }
//            }
//            .padding()
//            
//            CustomPopup(isPresented: Binding(
//                get: { viewModel.isEditTraning },
//                set: { viewModel.isEditTraning = $0 }
//            )) {
//                EditTrainingComponentView(reservationModel: viewModel.teamReservationCellInformation)
//            }
//            .transition(.scale)
//            .zIndex(1)
//            
//            CustomPopup(isPresented: Binding(
//                get: { viewModel.isRemoveTraning },
//                set: { viewModel.isRemoveTraning = $0 }
//            )) {
//                
//                CancelOrDeleteComponent(title: "CANCELAR RESERVA", subtitle: "¿Quieres cancelar este entrenamiento?") {
//                    self.viewModel.isRemoveTraning = false
//                } aceptedAction: {
//                    self.viewModel.isRemoveTraning = false
//                    //TODO: Remove this to backend
//                }
//            }
//            .transition(.scale)
//            .zIndex(1)
//            
//            CustomPopup(isPresented: Binding(
//                get: { viewModel.isCreateNewTraining },
//                set: { viewModel.isCreateNewTraining = $0 }
//            )) {
//                CreateNewTrainingView(viewModel: CreateNewTrainingViewModel(dateSelected: viewModel.dateSelected, availableHoursReservation: ["14:00", "15:00", "16:00", "17:00", "18:00", "19:00"], availableConsoleReservation: ["PC", "Xbox", "PlayStation", "Tablet"])) {
//                    self.viewModel.isCreateNewTraining = false
//                }
//            }
//            .transition(.scale)
//            .zIndex(1)
//        }
//    }
//}
//
//extension SeeReservationsOrCreateTeamTrainingComponentView {
////    private var titleBanner: some View {
////        Text("ENTRENAMIENTOS")
////            .font(.largeTitle)
////            .foregroundStyle(Color.white)
////    }
//    
//    private var calendarComponent: some View {
//        VStack (alignment: .center){
//            HStack {
//                TextWithUnderlineComponent(title: viewModel.isUserMode ? "Calendario" : "Calendario Entrenamientos", underlineColor: Color.cyan)
//                Spacer()
//            }
//            .padding(.top, 5)
//            .padding(.bottom, 25)
//            CustomCalendarView(canUserInteract: !viewModel.isUserMode, markedDates: viewModel.markedDates) { stringDate in
//                viewModel.dateSelected = stringDate
//                viewModel.isDateSelected = true
//            }
//            .frame(height: 250)
//        }
//    }
//    
//    private var nextTrainningBanner: some View {
//        VStack {
//            HStack {
//                TextWithUnderlineComponent(title: viewModel.isDateSelected ? "Entrenamientos" : "Próximos entrenamientos", underlineColor: Color.cyan)
//                
//                Spacer ()
//                if (viewModel.isDateSelected){
//                    Button {
//                        self.viewModel.isCreateNewTraining = true
//                    } label: {
//                        Image(systemName: "plus.circle.fill")
//                            .resizable()
//                            .frame(width: 40, height: 40)
//                            .clipShape(Circle())
//                            .foregroundStyle(Color.cyan)
//                    }
//                }
//                
//            }
//            .padding(.top, 20)
//            .padding(.bottom, 20)
//        }
//    }
//    
//    private var trainningTeamList: some View {
//        VStack(spacing: 20) {
//            ForEach(mockTeamReservationCellViewModel, id: \.id) { reservation in
//                TeamReservationCellComponentView(viewModel: TeamReservationCellComponentViewModel(trainingLocation: reservation.trainingLocation, dateSelected: reservation.dateSelected, hoursSelected: reservation.hoursSelected, playersAsigned: reservation.playersAsigned, descriptionText: reservation.descriptionText)) { optionSelected in
//                    
//                    viewModel.trainingTeamListCellPressed(teamSelectedInformation: reservation, optionSelected: optionSelected)
//                }
//            }
//        }
//        .padding()
//        
//    }
//    
//    private var trainningIndividualList: some View {
//        VStack(spacing: 20) {
//            ForEach(mockIndividualReservationCellViewModel, id: \.id) { reservation in
//                IndividualReservationCellComponent(viewModel: IndividualReservationCellComponentViewModel(trainingLocation: reservation.trainingLocation, teamAssigned: reservation.teamAssign, dateSelected: reservation.dateSelected, hourSelected: reservation.hoursSelected))
//            }
//        }
//        .padding()
//    }
//}
//
