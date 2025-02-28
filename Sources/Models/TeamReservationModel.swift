//
//  TeamReservationModel.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 15/10/24.
//

import SwiftUI

enum TeamReservationTrainningLocationSelected {
    case eSportsCenter
    case virtual
}

struct TeamReservationModel {
    let id = UUID()
    let trainingLocation: TeamReservationTrainningLocationSelected
    let dateSelected: String
    let hoursSelected: [String]
    let playersAsigned: [PlayerModel]
    let descriptionText: String
    let consoleSelected: String
}
