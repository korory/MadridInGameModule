//
//  UserModel.swift
//  Pods
//
//  Created by Arnau Rivas Rivas on 4/2/25.
//

struct UserModelResponse: Codable {
    let data : UserModel
}

struct UserModel: Codable {
    let id: String?
    let status: String?
    let username: String?
    let email: String?
    let dni: String?
    let token: String?
    let firstName: String?
    let lastName: String?
    let avatar: String?
    let reservesAllowed: Int?
    let phone: String?
    let address: String?
    let trainings: [Int]?
    let gamingSpaceReserves: [Int]?
    let invitations: [Int]?
    var teamsResponse: [TeamModelReal] = []
    var teams: [Int] = []
    var selectedTeam: TeamModelReal?
    var trainningsComplete: [TrainningsModel] = []
    var gammingSpacesComplete: [LoanModel] = []

    enum CodingKeys: String, CodingKey {
        case id, status, username, email, dni, token, firstName = "first_name", lastName = "last_name", avatar, address
        case reservesAllowed = "reserves_allowed"
        case phone, trainings, gamingSpaceReserves = "gaming_space_reserves", invitations
    }
}
