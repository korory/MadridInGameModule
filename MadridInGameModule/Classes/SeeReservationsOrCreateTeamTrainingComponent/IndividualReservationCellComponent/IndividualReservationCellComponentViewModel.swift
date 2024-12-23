//
//  IndividualReservationCellComponentViewModel.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 15/10/24.
//

import SwiftUI

class IndividualReservationCellComponentViewModel: ObservableObject {
    @Published var trainingLocation: IndividualReservationTrainningLocationSelected
    @Published var teamAssigned: TeamModel
    @Published var dateSelected: String
    @Published var hourSelected: String

    
    init(trainingLocation: IndividualReservationTrainningLocationSelected, teamAssigned: TeamModel, dateSelected: String, hourSelected: String) {
        self.trainingLocation = trainingLocation
        self.teamAssigned = teamAssigned
        self.dateSelected = dateSelected
        self.hourSelected = hourSelected
    }
    
    // Propiedad calculada para la imagen del sistema
    var trainingLocationImage: String {
        return trainingLocation == .virtual ? "desktopcomputer" : "building.columns"
    }
    
    // Función para obtener el texto de la ubicación
    func getTrainingLocationText() -> String {
        switch trainingLocation {
        case .eSportsCenter:
            return "E-CENTER"
        case .virtual:
            return "VIRTUAL"
        }
    }
}
