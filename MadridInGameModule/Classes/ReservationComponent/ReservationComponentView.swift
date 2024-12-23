//
//  ReservationComponentView.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 10/10/24.
//


import SwiftUI

struct ReservationComponentView: View {
    @StateObject private var viewModel = ReservationViewModel()
    
    var body: some View {
        ZStack {
            Color.blue
                .ignoresSafeArea()
            
            VStack(spacing: 10) {
                ScrollView {
                    calendarComponent
                    
                    if viewModel.dateSelected != "" {
                        selectHours
                    }
                    if !viewModel.hoursSelected.isEmpty {
                        selectConsoleType
                    }
                    
                    makeReservationButton
                    
                    Spacer()
                }
                .padding()
            }
            
            // Popup para ConfirmDNIView si la reserva es válida
            if viewModel.isReservationValid {
                CustomPopup(isPresented: Binding(
                    get: { viewModel.isReservationValid },
                    set: { viewModel.isReservationValid = $0 }
                )) {
                    ConfirmDNIView(action: { dni in
                        print("DNI recibido: \(dni)")
                        viewModel.isReservationValid = false
                        viewModel.isDNICorrect = true
                    })
                }
                .transition(.scale)
                .zIndex(1)
            }
            // Popup para ReservationQRView si el DNI es correcto
            else if viewModel.isDNICorrect {
                CustomPopup(isPresented: Binding(
                    get: { viewModel.isDNICorrect },
                    set: { viewModel.isDNICorrect = $0 }
                )) {
                    ReservationQRView(dateSelected: viewModel.dateSelected, hoursSelected: viewModel.hoursSelected, consoleSelected: viewModel.consoleSelected, code: "786", action: {
                        self.viewModel.isDNICorrect = false
                    })
                }
                .transition(.scale) // Animación opcional
                .zIndex(1) // Asegura que el popup esté por encima de otros elementos
            }
        }
    }
    
}
extension ReservationComponentView {
    private var calendarComponent: some View {
        CustomCalendarView(canUserInteract: true, markedDates:[]) { stringDate in
            viewModel.resetAll()
            viewModel.dateSelected = stringDate
        }
        .frame(height: 250)
    }
    
    private var selectHours: some View {
        VStack {
            Text(viewModel.dateSelected)
                .font(.headline)
                .foregroundStyle(Color.white)
                .padding()
            
            CustomSelectorButtons(items: viewModel.hoursReservation,
                                  selectedItems: $viewModel.hoursSelected, pressEnabled: true) { hour in
                viewModel.addRemoveHours(hour: hour)
            }
            
            Text("Máximo 3 spots consecutivos")
                .font(.body)
                .foregroundStyle(Color.white)
                .padding()
        }
    }
    
    private var selectConsoleType: some View {
        CustomSelectorButtons(items: viewModel.consoleReservation,
                              selectedItems: Binding(
                                get: { [viewModel.consoleSelected].compactMap { $0 } },
                                set: { viewModel.consoleSelected = $0.first ?? "" }
                              ), pressEnabled: true) { console in
                                  viewModel.consoleSelected = console
                              }
    }
    
    private var makeReservationButton: some View {
        VStack {
            CustomButton(text: "Reservar",
                         needsBackground: true,
                         backgroundColor: viewModel.dateSelected != "" && !viewModel.hoursSelected.isEmpty && viewModel.consoleSelected != "" ? Color.cyan : Color.gray,
                         pressEnabled: true,
                         widthButton: 180, heightButton: 50) {
                viewModel.reservationCall()
                viewModel.isReservationValid = true
            }
        }
        
    }
}

#Preview {
    ReservationComponentView()
}
