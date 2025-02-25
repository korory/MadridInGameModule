//
//  PlayersTeamComponentViewModel.swift
//  Pods
//
//  Created by Hamza El Hamdaoui on 27/1/25.
//

import SwiftUI

class PlayersTeamComponentViewModel: ObservableObject {
    @Published var teamName: String = ""
    @Published var teamPlayers: [PlayerModel] = []
    @Published var rolesAvailable: [String] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    init(user: UserModel?) {
        guard let user = user, let team = user.teamsResponse.first else {
            self.errorMessage = "El usuario no pertenece a ningún equipo"
            return
        }

        self.teamName = team.name ?? ""
        guard let users = team.users else { return }
//        self.teamPlayers = users.compactMap { userInfo in
//            let user = userInfo.userId
//            return PlayerModel(
//                id: user.id,
//                name: user.username,
//                image: UIImage(), roleAssign: userInfo.role?.name ?? "Sin rol"
//            )
//        }
        self.rolesAvailable = team.users?.compactMap { ($0.role?.name ?? "") } ?? []
    }
}
