//
//  IndividualReservationModel.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 15/10/24.
//

import SwiftUI

enum IndividualReservationTrainningLocationSelected {
    case eSportsCenter
    case virtual
}

struct IndividualReservationModel {
    let id = UUID()
    let trainingLocation: IndividualReservationTrainningLocationSelected
    let teamAssign: TeamModel
    let dateSelected: String
    let hoursSelected: String
}
