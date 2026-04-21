//
//  TextContentModel.swift
//  MadridInGameiOSModule
//

struct TextContentItem: Codable {
    let key: String
    let en: String?
    let es: String?
}

struct TextContentResponse: Codable {
    let data: [TextContentItem]
}
