//
//  IndividualReservationsComponentView.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 14/10/24.
//

import SwiftUI

struct IndividualReservationsComponentView: View {
    @StateObject var viewModel: IndividualReservationComponentViewModel
    @State private var isReservationFlowPresented = false
    
    var body: some View {
        VStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.black, Color.black, Color.black, Color.black.opacity(0.9)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea(.all)
                
                VStack (spacing: 20){
                    titleBanner
                    reservationsListComponent
                    Spacer()
                    reservationButton
                }
                .padding()
                
                CustomPopup(isPresented: Binding(
                    get: { viewModel.createReservation },
                    set: { viewModel.createReservation = $0 }
                )) {
                    ReservationComponentView()
                }
                .transition(.scale)
                .zIndex(1)
                .padding(.leading, 20)
                .padding(.trailing, 20)
                
                CustomPopup(isPresented: Binding(
                    get: { viewModel.seeReservation },
                    set: { viewModel.seeReservation = $0 }
                )) {
                    ReservationQRView(dateSelected: viewModel.reservationModel.dateSelected, hoursSelected: viewModel.reservationModel.hoursSelected, consoleSelected: viewModel.reservationModel.consoleSelected, code: "786") {
                        self.viewModel.seeReservation = false
                    }
                }
                .transition(.scale)
                .zIndex(1)
                
                CustomPopup(isPresented: $viewModel.cancelReservation) {
                    Group {
                        if let reservation = viewModel.selectedReservation {
                            CancelOrDeleteComponent(
                                title: "CANCELAR RESERVA",
                                subtitle: "¿Quieres cancelar la reserva del día \(reservation.date.formatted(date: .numeric, time: .omitted))?"
                            ) {
                                viewModel.cancelReservation = false
                            } aceptedAction: {
                                viewModel.deleteReservation()
                            }
                        } else {
                            EmptyView()
                        }
                    }
                }
                .transition(.scale)
                .zIndex(1)
            }
        }
        .sheet(isPresented: $isReservationFlowPresented) {
            ReservationFlowView(
                            isPresented: $isReservationFlowPresented,
                            viewModel: ReservationFlowViewModel(onReservationSuccess: {
                                viewModel.fetchReservations()
                                isReservationFlowPresented = false
                            }, onReservationFail: {
                                isReservationFlowPresented = false
                            })
                        )
                }
    }
}

extension IndividualReservationsComponentView {
    private var titleBanner: some View {
        HStack {
            Text("RESERVAS INDIVIDUALES")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(Color.white)
            Spacer()
        }
    }
    
    private var reservationsListComponent: some View {
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(viewModel.reservations, id: \.id) { reservation in
                        IndividualReservationsCellComponent(
                            reservation: reservation) { optionPressed, reservation in
                            switch optionPressed {
                                                    case .cancelReservation:
                                                        viewModel.isCancelReservationButtonPressed(for: reservation)
                                                    case .seeReservation:
                                                        viewModel.isSeeReservationButtonPressed()
                                                    }
                        }
                    }
                }
            }
            .padding()
        }
    
    private var reservationButton: some View {
        CustomButton(text: "Reservar",
                     needsBackground: true,
                     backgroundColor: Color.cyan,
                     pressEnabled: true,
                     widthButton: 280, heightButton: 50) {
            //viewModel.isCreateReservationButtonPressed()
            self.isReservationFlowPresented = true
        }
    }
}

