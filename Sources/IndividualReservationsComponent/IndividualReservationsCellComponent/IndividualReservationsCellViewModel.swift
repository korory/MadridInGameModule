//
//  IndividualReservationsCellViewModel.swift
//  Pods
//
//  Created by Arnau Rivas Rivas on 20/2/25.
//


import SwiftUI

class IndividualReservationsCellViewModel: ObservableObject {
    @Published var reservation: IndividualReservation
    var showDeleteOption: Bool
    
    init(reservation: IndividualReservation, showDeleteOption: Bool) {
        self.reservation = reservation
        self.showDeleteOption = showDeleteOption
    }
    
    func getReservationConsole() -> String {
        return reservation.gamingSpaces.first?.translations.first?.device ?? ""
    }
    
    func formatTimes() -> String {
        return reservation.times.map { $0.gamingSpaceTimesID?.time ?? "0" }.joined(separator: ", ")
    }
    
    func parseReservationDate() -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"

        if let date = inputFormatter.date(from: reservation.date) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "dd/MM/yyyy"
            let formattedDate = outputFormatter.string(from: date)
            return formattedDate
        }
        
        return "No Fecha"
    }
    
    func handleAction(_ action: IndividualReservationsCellOptions) {
        switch action {
        case .seeReservation:
            print("Ver reserva: \(reservation.id ?? 0)")
            // Aquí podrías agregar navegación o lógica adicional
        case .cancelReservation:
            print("Cancelar reserva: \(reservation.id ?? 0)")
            // Aquí podrías manejar la cancelación de la reserva
        }
    }
}
