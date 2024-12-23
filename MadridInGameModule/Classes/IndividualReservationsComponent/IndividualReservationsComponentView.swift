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
                Color.black
                    //.opacity(0.7)
                    .ignoresSafeArea(edges: .all)
                
                VStack (spacing: 20){
                    titleBanner
                    reservationsCellComponent
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
                
                CustomPopup(isPresented: Binding(
                    get: { viewModel.cancelReservation },
                    set: { viewModel.cancelReservation = $0 }
                )) {
                    CancelOrDeleteComponent(title: "CANCELAR RESERVA", subtitle: "¿Quieres cancelar la reserva del día \(viewModel.reservationModel.dateSelected)") {
                        self.viewModel.cancelReservation = false
                    } aceptedAction: {
                        self.viewModel.cancelReservation = false
                        //TODO: Delete reservation to the Backend
                    }
                }
                .transition(.scale)
                .zIndex(1)
            }
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
    
    private var reservationsCellComponent: some View {
        IndividualReservationsCellComponent(consoleSelected: viewModel.reservationModel.consoleSelected, date: viewModel.reservationModel.dateSelected, hours: viewModel.reservationModel.hoursSelected) { optionPressed, consoleSelected, dateSelected, hoursSelected in
            viewModel.isCellIsPressed(optionPressed, consoleSelected, dateSelected, hoursSelected)
        }
        .padding()
    }
    
    private var reservationButton: some View {
        CustomButton(text: "Reservar",
                     needsBackground: true,
                     backgroundColor: Color.cyan,
                     pressEnabled: true,
                     widthButton: 280, heightButton: 50) {
            viewModel.isCreateReservationButtonPressed()
        }
    }
}

