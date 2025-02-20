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
                
                if viewModel.isLoading {
                    VStack {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.purple))
                            .scaleEffect(1.5)
                            .padding()
                        
                        Text("Obteniendo tus reservas...")
                            .font(.custom("Madridingamefont-Regular", size: 15))
                            .foregroundColor(.white)
                            .opacity(0.7)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
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
                        if let reservation = viewModel.selectedReservation {
                            CancelOrDeleteComponent(
                                title: "CANCELAR RESERVA",
                                subtitle: "¿Quieres cancelar la reserva del día \(reservation.date.formatted(date: .numeric, time: .omitted))?"
                            ) {
                                viewModel.cancelReservation = false
                            } aceptedAction: {
                                //viewModel.deleteReservation()
                            }
                        } else {
                            EmptyView()
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
                    viewModel.fetchReservations {
                        viewModel.isLoading = false
                    }
                    viewModel.isReservationFlowPresented = false
                }, onReservationFail: {
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
    
    //    private var trainningTeamList: some View {
    //        ScrollView {
    //            VStack(alignment: .leading, spacing: 20) {
    //                if !viewModel.allIndividualReservations.isEmpty {
    //                    ForEach(viewModel.allIndividualReservations, id: \.id) { individualReservation in
    //                        IndividualReservationsCellComponent(viewModel: IndividualReservationsCellViewModel(reservation: individualReservation)) { optionSelected in
    //                            //                        viewModel.trainingIndividualListCellPressed(individualSelectedInformation: individualReservation, optionSelected: optionSelected)
    //                        }
    //                    }
    //                }
    //
    //            }
    //            .padding(5)
    //        }
    //        .refreshable {
    //            await viewModel.getAndRefreshReservationsData()
    //        }
    //    }
    
    private var trainningTeamList: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ForEach(viewModel.allIndividualReservations, id: \.id) { individualReservation in
                    IndividualReservationsCellComponent(
                        viewModel: IndividualReservationsCellViewModel(reservation: individualReservation)
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
                     backgroundColor: viewModel.allIndividualReservations.count < 3 ? Color.cyan : Color.gray,
                     pressEnabled: true,
                     widthButton: 280, heightButton: 50) {
            if viewModel.allIndividualReservations.count < 3 {
                self.viewModel.isReservationFlowPresented = true
            } else {
                self.viewModel.noReservationAllowed = true
            }
        }
    }
}

