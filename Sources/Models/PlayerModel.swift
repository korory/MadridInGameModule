//
//  PlayerModel.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 15/10/24.
//

import SwiftUI

struct PlayerModel: Codable {
    let id: String
    let email: String
    let name: String
    let avatar: String
    //let image: UIImage
    //let roleAssign: String
    
    enum CodingKeys: String, CodingKey {
        case id, email, avatar
        case name = "first_name"
    }
}
