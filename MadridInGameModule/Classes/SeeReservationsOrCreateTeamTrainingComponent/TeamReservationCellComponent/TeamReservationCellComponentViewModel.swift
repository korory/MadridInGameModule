//
//  TeamReservationCellComponentViewModel.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 15/10/24.
//

import SwiftUI

enum TeamReservationCellComponentOptionSelected {
    case removeCell
    case seeDetails
    //case editTraining
}

import SwiftUI

class TeamReservationCellComponentViewModel: ObservableObject {
    @Published var reservation: EventModel
    
    init(reservation: EventModel) {
        self.reservation = reservation
    }
    
    func getSystemImageNameOfReservationBasedOnType() -> String {
        //If reserves is empty that means that the reserve is online
        guard let reservationLocal = reservation.reserves else { return "desktopcomputer" }
        
        if reservationLocal.isEmpty {
            return "desktopcomputer"
        } else {
            return "building"
        }
    }
    
    func parseTimeDeleteSeconds() -> String {
        let parts = reservation.time.split(separator: ":")
        let hourWithoutSeconds = "\(parts[0]):\(parts[1])"

        return hourWithoutSeconds
    }
    
    func getAllPlayers() -> [PlayerUsersModel] {
        guard let allPlayers = reservation.players else { return [] }
        return allPlayers
    }
    
    func parseReservationDate() -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"

        if let date = inputFormatter.date(from: reservation.startDate) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "dd/MM/yyyy"
            let formattedDate = outputFormatter.string(from: date)
            return formattedDate
        }
        
        return "No Fecha"
    }
    
    func performAction(_ optionSelected: TeamReservationCellComponentOptionSelected, action: (_ optionSelected: TeamReservationCellComponentOptionSelected) -> Void) {
        action(optionSelected)
    }
}
