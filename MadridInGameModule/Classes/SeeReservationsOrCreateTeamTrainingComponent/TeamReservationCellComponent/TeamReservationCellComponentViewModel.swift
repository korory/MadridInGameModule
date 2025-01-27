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
    case editTraining
}

import SwiftUI

class TeamReservationCellComponentViewModel: ObservableObject {
    @Published var reservation: TeamReservation
    
    init(reservation: TeamReservation) {
        self.reservation = reservation
    }
    
    // Propiedad calculada para la imagen del sistema
    var trainingLocationImage: String {
        "desktopcomputer" // Ajusta según la lógica si hay más ubicaciones en el futuro
    }
    
    // Propiedad para obtener la fecha formateada
    var formattedDate: String {
        reservation.date.formatted(date: .numeric, time: .omitted)
    }
    
    // Propiedad para obtener las horas seleccionadas como texto
    var formattedHours: String {
        let hours = reservation.times.map { $0.time }
        return hours.count > 1 ? "Horas: \(hours.joined(separator: ", "))" : "Hora: \(hours.first ?? "")"
    }
    
    // Función para manejar las acciones del componente
    func performAction(_ optionSelected: TeamReservationCellComponentOptionSelected, action: (_ optionSelected: TeamReservationCellComponentOptionSelected) -> Void) {
        action(optionSelected)
    }
}
