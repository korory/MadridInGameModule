//
//  NewsModel.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 17/10/24.
//

struct NewsModelResponse: Codable {
    let data: [NewsModel]
}

struct NewsModel: Identifiable, Codable {
    let id: Int
    let title: String?
    let body: String?
    let date: String?
    let image: String?
    let status: String?
}
