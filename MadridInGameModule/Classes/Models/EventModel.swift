//
//  EventModel.swift
//  Pods
//
//  Created by Arnau Rivas Rivas on 10/2/25.
//


import Foundation

struct EventModelResponse: Codable {
    let data: [EventModel]
}

struct EventModel: Codable {
    var id: String
    var notes: String
    var players: [Int]
    var reserves: [Int]
    var startDate: String
    var status: String
    var time: String
    var type: String

    enum CodingKeys: String, CodingKey {
        case id
        case notes
        case players
        case reserves
        case startDate = "start_date"
        case status
        case time
        case type
    }
}
