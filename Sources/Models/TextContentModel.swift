//
//  TextContentModel.swift
//  Pods
//
//  Created by Arnau Rivas Rivas on 20/4/25.
//

struct TextContentResponse: Codable {
    let data: [TextContentItem]
}

struct TextContentItem: Codable {
    let key: String?
    let en: String?
    let es: String?
}
