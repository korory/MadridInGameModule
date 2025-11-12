//
//  TeamReservationModel.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 15/10/24.
//

import SwiftUI

enum TeamReservationTrainingLocationSelected {
    case eSportsCenter
    case virtual
}

struct TeamReservationModel {
    let id = UUID()
    let trainingLocation: TeamReservationTrainingLocationSelected
    let dateSelected: String
    let hoursSelected: [String]
    let playersAsigned: [PlayerModel]
    let descriptionText: String
    let consoleSelected: String
}
