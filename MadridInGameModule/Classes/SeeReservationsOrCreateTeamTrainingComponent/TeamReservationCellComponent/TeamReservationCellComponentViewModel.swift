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

class TeamReservationCellComponentViewModel: ObservableObject {
    @Published var trainingLocation: TeamReservationTrainningLocationSelected
    @Published var dateSelected: String
    @Published var hoursSelected: [String]
    @Published var players: [PlayerModel]
    @Published var descriptionText: String

    
    init(trainingLocation: TeamReservationTrainningLocationSelected, dateSelected: String, hoursSelected: [String], playersAsigned: [PlayerModel], descriptionText: String) {
        self.trainingLocation = trainingLocation
        self.dateSelected = dateSelected
        self.hoursSelected = hoursSelected
        self.players = playersAsigned
        self.descriptionText = descriptionText
    }
    
    // Propiedad calculada para la imagen del sistema
    var trainingLocationImage: String {
        return trainingLocation == .virtual ? "desktopcomputer" : "building.columns"
    }
    
    // Función para obtener el texto de la ubicación
    func getTrainingLocationText() -> String {
        switch trainingLocation {
        case .eSportsCenter:
            return "ESPORTS CENTER"
        case .virtual:
            return "VIRTUAL"
        }
    }
    
    // Función para manejar las acciones del componente
    func performAction(_ optionSelected: TeamReservationCellComponentOptionSelected, action: (_ optionSelected: TeamReservationCellComponentOptionSelected) -> Void) {
        action(optionSelected)
    }
}

