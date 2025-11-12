//
//  IndividualReservationsComponentView.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 14/10/24.
//

import SwiftUI

struct IndividualReservationsComponentView: View {
    @StateObject var viewModel: IndividualReservationComponentViewModel
    
    var body: some View {
        VStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.black, Color.black, Color.black, Color.white.opacity(0.15)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea(.all)
                
                if viewModel.showToastSuccess {
                    ToastMessage(message: "¡Reserva Realizada!", duration: 2, success: true) {
                        self.viewModel.showToastSuccess = false
                    }
                    .zIndex(1)
                } else if viewModel.showToastFailure {
                    ToastMessage(message: "Problema al crear una reserva", duration: 2, success: false) {
                        self.viewModel.showToastFailure = false
                    }
                    .zIndex(1)
                } else if viewModel.showToastDeleteSuccess {
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
                    LoadingView(message: "Obteniendo tus reservas...")
                    
                } else {
                    VStack (spacing: 10){
                        titleBanner
                        if viewModel.allIndividualReservations.isEmpty {
                            noReservationAvailable
                        } else {
                            trainingTeamList
                        }
                        Spacer()
                        reservationButton
                    }
                    .padding()
                }
                
                CustomPopup(isPresented: Binding(
                    get: { viewModel.cancelReservation },
                    set: { viewModel.cancelReservation = $0 }
                )) {
                    Group {
                        let subtitle = if let description = viewModel.individualSelectedInformation?.friendlyDescription {
                            "¿Quieres cancelar la reserva del \(description)?"
                        } else {
                            "¿Quieres cancelar la reserva?"
                        }
                        
                        CancelOrDeleteComponent(
                            title: "CANCELAR RESERVA",
                            subtitle: subtitle,
                            acceptTitle: "Sí",
                            cancelTitle: "No"
                        ) {
                            viewModel.cancelReservation = false
                        } acceptedAction: {
                            viewModel.deleteReservation()
                        }
                    }
                }
                .transition(.scale)
                .zIndex(1)
                
                CustomPopup(isPresented: $viewModel.noReservationAllowed) {
                    VStack (spacing: 10){
                        Text("Se ha alcanzado el máximo de reservas solicitadas")
                            .font(.madridInGameiOSFont(size: 17))
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                .transition(.scale)
                .zIndex(1)
                
                CustomPopup(isPresented: $viewModel.noReservationAllowedWithoutDNI) {
                    VStack (spacing: 10){
                        Text("Se ha alcanzado el máximo de reservas solicitadas para usuarios no verificados. Por favor, verifica tu DNI y vuelve a intentarlo.")
                            .font(.madridInGameiOSFont(size: 17))
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                .transition(.scale)
                .zIndex(1)
            }
        }
        .sheet(isPresented: $viewModel.isReservationFlowPresented) {
            ReservationFlowView(
                isPresented: $viewModel.isReservationFlowPresented,
                viewModel: ReservationFlowViewModel(onReservationSuccess: {
                    viewModel.allIndividualReservations.removeAll()
                    viewModel.fetchReservations {
                        viewModel.isLoading = false
                    }
                    viewModel.showToastSuccess = true
                    viewModel.isReservationFlowPresented = false
                }, onReservationFail: {
                    viewModel.showToastFailure = true
                    viewModel.isReservationFlowPresented = false
                })
            )
        }
        .sheet(isPresented: $viewModel.isSelectTraning) {
            ReservationIndividualCardComponent(viewModel: ReservationIndividualCardViewModel(reservation: self.viewModel.getIndividualReservation()))
                .zIndex(1)
        }
        .onAppear {
            self.viewModel.getAndRefreshReservationsData()
        }
        .overlay {
            if self.viewModel.dniIsMissing {
                VStack {
                    ConfirmDNIView { value in
                        if !value.isEmpty {
                            self.viewModel.setDNIToTheUser(value)
                        }
                        self.viewModel.dniIsMissing = false
                    }
                }
                .background(.black)
                .padding(.bottom, 20)
            }
        }
    }
}

extension IndividualReservationsComponentView {
    private var titleBanner: some View {
        HStack {
            Text("RESERVAS INDIVIDUALES")
                .font(.madridInGameiOSFont(size: 20))
                .fontWeight(.bold)
                .foregroundStyle(Color.white)
            Spacer()
            
            Button {
                self.viewModel.getAndRefreshReservationsData()
            } label: {
                Image(systemName: "arrow.clockwise.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 28, height: 28)
                    .foregroundColor(.cyan)
            }
            
        }
    }
    
    private var trainingTeamList: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ForEach(viewModel.allIndividualReservations, id: \.id) { individualReservation in
                    IndividualReservationsCellComponent(
                        viewModel: IndividualReservationsCellViewModel(reservation: individualReservation, showDeleteOption: true)
                    ) { optionSelected in
                        viewModel.trainingIndividualListCellPressed(individualSelectedInformation: individualReservation, optionSelected: optionSelected)
                    }
                }
            }
            .padding(5)
        }
    }
    
    private var noReservationAvailable: some View {
        VStack(alignment: .center, spacing: 20) {
            Spacer()
            Text("No hay reservas")
                .font(.madridInGameiOSFont(size: 18))
                .foregroundStyle(Color.white)
            Spacer()
        }
    }
    
    @ViewBuilder
    private var reservationButton: some View {
        let backgroundColor: Color = if let user = viewModel.userManager.getUser() {
            if viewModel.allIndividualReservations.count < user.numberOfBookingsAllowed {
                Color.cyan
            } else {
                Color.gray
            }
        } else {
            Color.gray
        }
        
        CustomButton(text: "Reservar",
                     needsBackground: true,
                     backgroundColor: backgroundColor,
                     pressEnabled: true,
                     widthButton: 280, heightButton: 50) {
            guard let user = viewModel.userManager.getUser() else {
                viewModel.noReservationAllowed = true
                return
            }
            
            if viewModel.allIndividualReservations.count >= user.numberOfBookingsAllowed && user.isUserActive {
                viewModel.noReservationAllowed = true
                return
            } else if viewModel.allIndividualReservations.count >= user.numberOfBookingsAllowed && !user.isUserActive {
                viewModel.noReservationAllowedWithoutDNI = true
            } else {
                // check for dni
                if user.isDNIAvailable {
                    viewModel.isReservationFlowPresented = true
                } else {
                    viewModel.dniIsMissing = true
                }
            }
        }
    }
}

extension IndividualReservation {
    var friendlyDescription: String? {
        if let date = Date.dateFromString(date: date) {
            let formattedDate = date.toUIDateString()
            if let time = times.first?.gamingSpaceTimesID?.time {
                return "\(formattedDate) - \(time)"
            } else {
                return "\(formattedDate)"
            }
        } else {
            return nil
        }
    }
}
