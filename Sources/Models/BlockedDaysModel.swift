//
//  BlockedDaysModel.swift
//  Pods
//
//  Created by Arnau Rivas Rivas on 24/2/25.
//

struct BlockedDaysModelResponse : Codable {
    let data: [BlockedDaysModel]
}

struct BlockedDaysModel : Identifiable, Codable {
    let id: Int
    let date: String?
    let description: String?
}
