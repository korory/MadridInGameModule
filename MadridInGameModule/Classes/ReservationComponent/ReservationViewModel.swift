//
//  ReservationViewModel.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 10/10/24.
//


import SwiftUI

enum PopupContent {
    case confirmDNI
    case visitQR
}

class ReservationViewModel: ObservableObject {
    let hoursReservation: [String] = ["14:00", "15:00", "16:00", "17:00", "18:00", "19:00"]
    let consoleReservation: [String] = ["PC", "Xbox", "PlayStation", "Tablet"]

    @Published var dateSelected: String = ""
    @Published var hoursSelected: [String] = []
    @Published var consoleSelected: String = ""
    @Published var isReservationValid: Bool = false
    @Published var isDNICorrect: Bool = false
    @Published var popupContent: PopupContent = .confirmDNI

    func resetAll() {
        dateSelected = ""
        hoursSelected.removeAll()
        consoleSelected = ""
    }

    func addRemoveHours(hour: String) {
        if let index = hoursSelected.firstIndex(of: hour) {
            hoursSelected.remove(at: index)
            if hoursSelected.isEmpty {
                consoleSelected = ""
            }
        } else {
            if hoursSelected.count < 3 {
                hoursSelected.append(hour)
            }
        }
        isReservationValid = false
    }
    
    func reservationCall() {
        guard !dateSelected.isEmpty, !hoursSelected.isEmpty, !consoleSelected.isEmpty else { return }
        
        /*
        let times = hoursSelected.map { GamingTime(gaming_space_times_id: GamingTimeID(id: $0)) }
        let reservation = Reservation(date: dateSelected, user: "USER_ID", slot: consoleSelected, times: [])
         */
        
        /*/let reservation = Reservation(id: 0, status: "", slot: 0, date: "22-04-2022", user: "", times: [])
        
        let service = ReservationService()
        service.createReservation(reservation: reservation) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.isReservationValid = true
                    print("Reservation created successfully")
                case .failure(let error):
                    self?.isReservationValid = false
                    print("Error creating reservation: \(error)")
                }
            }
        }*/
    }
}
