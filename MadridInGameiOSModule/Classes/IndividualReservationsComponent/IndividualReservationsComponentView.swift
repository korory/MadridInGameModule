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
                        trainningTeamList
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
                        CancelOrDeleteComponent(
                            title: "CANCELAR RESERVA",
                            subtitle: "¿Quieres cancelar esta reserva?"
                        ) {
                            viewModel.cancelReservation = false
                        } aceptedAction: {
                            viewModel.deleteReservation()
                        }
                    }
                }
                .transition(.scale)
                .zIndex(1)
                
                CustomPopup(isPresented: $viewModel.noReservationAllowed) {
                    VStack (spacing: 10){
                        Text("Se ha alcanzado el máximo de reservas solicitadas")
                            .font(.custom("Madridingamefont-Regular", size: 17))
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
    }
}

extension IndividualReservationsComponentView {
    private var titleBanner: some View {
        HStack {
            Text("RESERVAS INDIVIDUALES")
                .font(.custom("Madridingamefont-Regular", size: 20))
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
    
    private var trainningTeamList: some View {
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
    
    
    private var reservationButton: some View {
        CustomButton(text: "Reservar",
                     needsBackground: true,
                     backgroundColor: viewModel.allIndividualReservations.count < viewModel.userManager.getUser()?.reservesAllowed ?? 1 ? Color.cyan : Color.gray,
                     pressEnabled: true,
                     widthButton: 280, heightButton: 50) {
            if viewModel.allIndividualReservations.count < viewModel.userManager.getUser()?.reservesAllowed ?? 1  {
                self.viewModel.isReservationFlowPresented = true
            } else {
                self.viewModel.noReservationAllowed = true
            }
        }
    }
}

