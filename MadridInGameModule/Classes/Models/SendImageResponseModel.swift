//
//  ApiResponse.swift
//  Pods
//
//  Created by Arnau Rivas Rivas on 25/2/25.
//


import Foundation

// Modelo principal que representa la respuesta de la API
struct SendImageResponse: Codable {
    let data: FileData
}

// Modelo que representa los datos de la imagen subida
struct FileData: Codable {
    let id: String
    let storage: String
    let filenameDisk: String
    let filenameDownload: String
    let title: String
    let type: String
    let folder: String?
    let uploadedBy: String
    let uploadedOn: String
    let modifiedBy: String?
    let modifiedOn: String?
    let charset: String?
    let filesize: String
    let width: Int
    let height: Int
    let duration: Int?
    let embed: String?
    let description: String?
    let location: String?
    let tags: [String]?
    let metadata: [String: String]?
    
    enum CodingKeys: String, CodingKey {
        case id, storage, title, type, folder, charset, filesize, width, height, duration, embed, description, location, tags, metadata
        case filenameDisk = "filename_disk"
        case filenameDownload = "filename_download"
        case uploadedBy = "uploaded_by"
        case uploadedOn = "uploaded_on"
        case modifiedBy = "modified_by"
        case modifiedOn = "modified_on"
    }
}
