//
//  ReservationsComponentView.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 14/10/24.
//

import SwiftUI

struct ReservationsComponentView: View {
    @StateObject var viewModel: ReservationComponentViewModel

    var body: some View {
        VStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.black, Color.black, Color.black, Color.white.opacity(0.15)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea(.all)

                if viewModel.showToastSuccess {
                    ToastMessage(message: "¡Reserva Realizada!".localized, duration: 2, success: true) {
                        self.viewModel.showToastSuccess = false
                    }
                    .zIndex(1)
                } else if viewModel.showToastFailure {
                    ToastMessage(message: "Problema al crear una reserva".localized, duration: 2, success: false) {
                        self.viewModel.showToastFailure = false
                    }
                    .zIndex(1)
                } else if viewModel.showToastDeleteSuccess {
                    ToastMessage(message: "Reserva Eliminada".localized, duration: 2, success: true) {
                        self.viewModel.showToastDeleteSuccess = false
                    }
                    .zIndex(1)
                } else if viewModel.showToastDeleteFailure {
                    ToastMessage(message: "Problema al eliminar una reserva".localized, duration: 2, success: false) {
                        self.viewModel.showToastDeleteFailure = false
                    }
                    .zIndex(1)
                }

                if viewModel.isLoading {
                    LoadingView(message: "Obteniendo tus reservas...".localized)

                } else {
                    VStack(spacing: 10) {
                        titleBanner
                        if isReservationListEmpty {
                            noReservationAvailable
                        } else {
                            trainingTeamList
                        }
                        Spacer()

                        if self.viewModel.personalReservations {
                            reservationButton
                        } else {
                            if self.viewModel.getUserRol() == "Manager" {
                                reservationButton
                            }
                        }
                    }
                    .padding()
                }

                CustomPopup(isPresented: Binding(
                    get: { viewModel.cancelReservation },
                    set: { viewModel.cancelReservation = $0 }
                ), onDismiss: {
                    self.viewModel.resetScreen()
                }) {
                    Group {
                        let isTeam = viewModel.teamSelectedInformation != nil && viewModel.individualSelectedInformation == nil

                        let subtitle = if let description = viewModel.individualSelectedInformation?.friendlyDescription {
                            "¿Quieres cancelar la reserva del %@?".localized(description)
                        } else {
                            "¿Quieres cancelar la reserva?".localized
                        }

                        CancelOrDeleteComponent(
                            title: "CANCELAR RESERVA".localized,
                            subtitle: subtitle,
                            acceptTitle: "Sí".localized,
                            cancelTitle: "No".localized
                        ) {
                            viewModel.cancelReservation = false
                            self.viewModel.resetScreen()
                        } acceptedAction: {
                            viewModel.deleteReservation(isTeamSelected: isTeam)
                            self.viewModel.teamSelectedInformation = nil
                            self.viewModel.individualSelectedInformation = nil
                        }
                    }
                }
                .transition(.scale)
                .zIndex(1)

                CustomPopup(isPresented: $viewModel.noReservationAllowed,
                onDismiss: {
                    self.viewModel.resetScreen()
                }) {
                    VStack(spacing: 10) {
                        Text("Se ha alcanzado el máximo de reservas solicitadas".localized)
                            .font(.madridInGameiOSFont(size: 17))
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                .transition(.scale)
                .zIndex(1)

                CustomPopup(isPresented: $viewModel.noReservationAllowedWithoutDNI, onDismiss: {
                    self.viewModel.resetScreen()
                })  {
                    VStack(spacing: 10) {
                        Text("Se ha alcanzado el máximo de reservas solicitadas para usuarios no verificados. Por favor, verifica tu DNI y vuelve a intentarlo.".localized)
                            .font(.madridInGameiOSFont(size: 17))
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                .transition(.scale)
                .zIndex(1)
            }
        }
        .sheet(isPresented: $viewModel.isReservationFlowPresented , onDismiss: {
            self.viewModel.resetScreen()
        }) {
            ReservationFlowView(
                isPresented: $viewModel.isReservationFlowPresented,
                viewModel: ReservationFlowViewModel(personalReservations: self.viewModel.personalReservations, teamReservationInformation: self.viewModel.teamSelectedInformation, individualReservationInformation: self.viewModel.individualSelectedInformation, onReservationSuccess: {
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
        .sheet(isPresented: $viewModel.isSelectTranning) {
            if viewModel.personalReservations {
                ReservationIndividualCardComponent(viewModel: ReservationIndividualCardViewModel(reservation: self.viewModel.getIndividualReservation()))
                    .zIndex(1)
            } else if let teamReservation = viewModel.teamSelectedInformation {
                ReservationCardComponent(viewModel: ReservationCardViewModel(reservation: teamReservation))
                    .zIndex(1)
            }
        }
        .onAppear {
            self.viewModel.resetScreen()
        }
        .onChange(of: viewModel.showToastSuccess) { newValue in
            if newValue && !viewModel.personalReservations{
                self.viewModel.resetScreen()
            }
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

    private var isReservationListEmpty: Bool {
        viewModel.personalReservations
            ? viewModel.allIndividualReservations.isEmpty
            : viewModel.allTeamReservations.isEmpty
    }
}

extension ReservationsComponentView {
    private var titleBanner: some View {
        HStack {
            Text(self.viewModel.personalReservations ? "RESERVAS INDIVIDUALES".localized : "RESERVAS DE EQUIPO".localized)
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
                if viewModel.personalReservations {
                    ForEach(viewModel.allIndividualReservations, id: \.id) { individualReservation in
                        IndividualReservationsCellComponent(
                            viewModel: IndividualReservationsCellViewModel(reservation: individualReservation, showDeleteAndEditOption: true)
                        ) { optionSelected in
                            viewModel.trainingIndividualListCellPressed(individualSelectedInformation: individualReservation, optionSelected: optionSelected)
                        }
                    }
                } else {
                    ForEach(viewModel.allTeamReservations, id: \.id) { reservation in
                        TeamReservationCellComponentView(
                            viewModel: TeamReservationCellComponentViewModel(reservation: reservation, showDeleteAndEditOption: self.viewModel.getUserRol().lowercased() == "manager" ? true : ( self.viewModel.getUserRol().lowercased() == "trainer" ? true : false))
                        ) { optionSelected in
                            viewModel.trainingTeamListCellPressed(teamSelectedInformation: reservation, optionSelected: optionSelected)
                        }
                    }
                }
            }
            .padding(5)
        }
    }

    private var noReservationAvailable: some View {
        VStack(alignment: .center, spacing: 20) {
            Spacer()
            Text("No hay reservas".localized)
                .font(.madridInGameiOSFont(size: 18))
                .foregroundStyle(Color.white)
            Spacer()
        }
    }

    @ViewBuilder
    private var reservationButton: some View {
        let canBook = viewModel.personalReservations
            ? viewModel.userCanBook()
            : viewModel.teamCanBook()

        CustomButton(text: "Reservar".localized,
                     needsBackground: true,
                     backgroundColor: canBook ? Color.cyan : Color.gray,
                     pressEnabled: true,
                     widthButton: 280, heightButton: 50) {
            self.viewModel.openReservationFlowIfAllowed()
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
