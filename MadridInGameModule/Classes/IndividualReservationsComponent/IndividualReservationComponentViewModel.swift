//
//  IndividualReservationComponentViewModel.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 15/10/24.
//

import SwiftUI

class IndividualReservationComponentViewModel: ObservableObject {
    @Published var createReservation: Bool = false
    @Published var seeReservation: Bool = false
    @Published var cancelReservation: Bool = false
    @Published var reservationModel: ReservationQRModel
    
    init(reservationModel: ReservationQRModel) {
        self.reservationModel = reservationModel
    }
    
    func isSeeReservationButtonPressed() {
        self.seeReservation.toggle()
    }
    
    func isCancelReservationButtonPressed() {
        self.cancelReservation.toggle()
    }
    
    func isCreateReservationButtonPressed() {
        self.createReservation.toggle()
    }
    
    func isCellIsPressed(_ optionSelected: IndividualReservationsCellOptions, _ consoleReservation: String, _ dateReservation: String, _ hoursReservation: [String]) {
        
        self.reservationModel.consoleSelected = consoleReservation
        self.reservationModel.dateSelected = dateReservation
        self.reservationModel.hoursSelected = hoursReservation
        
        switch (optionSelected) {
        case .seeReservation:
            self.isSeeReservationButtonPressed()
        case .cancelReservarion:
            self.isCancelReservationButtonPressed()
        }
    }
}
