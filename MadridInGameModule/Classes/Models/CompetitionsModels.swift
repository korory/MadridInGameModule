//
//  CompetitionsModels.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 17/10/24.
//

import Foundation
import UIKit

enum competitionType {
    case pokemon
    case clashRoyale
    case fornite
    case valorant
    case lol
    case fifa
    case callOfDutty
    case rocketLeague
}
struct CompetitionsModel {
    var seasons: [SeasonsModelMock]
}

struct SeasonsModelMock {
    var id = UUID()
    var year: String
    var mundialLeague: [LeagueModelMock]
}

struct SeasonsModel {
    var id = UUID()
    var year: String
    let isOptionSelected: Bool
}

struct LeagueModel: Identifiable {
    var id = UUID()
    var title: String
    var seriesTitle: String
    var description: String
    var allCompetitions: [CompetitionData]
}

struct LeagueModelMock {
    var id = UUID()
    var title: String
    var seriesTitle: String
    var description: String
    var competitions: [CompetitionsDetailModel]
}

struct CompetitionsDetailModel {
    var id = UUID()
    var competitionType: competitionType
    var title: String
    var allSplitsAvailable: [SplitsModel]
}

struct SplitsModel {
    var title: String
    var bannerImage: UIImage
    var overviewDescription: String
    var details: String
    var rules: String
    var contact: String
}
