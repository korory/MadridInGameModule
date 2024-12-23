//
//  TeamModel.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 15/10/24.
//

import SwiftUI

struct TeamModel {
    let id = UUID()
    var name: String
    var descriptionText: String
    var discordLink: String
    var image: UIImage
    var allRolesAvailable: [String]
    var allPlayersAssigned: [PlayerModel]
}
