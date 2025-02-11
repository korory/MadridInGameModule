//
//  Utils.swift
//  Pods
//
//  Created by Arnau Rivas Rivas on 4/2/25.
//


import Foundation
import SwiftUICore

class Utils {
    static func createDate(from dateString: String) -> Date? {
        let components = dateString.split(separator: "-").compactMap { Int($0) }
        
        guard components.count == 3,
              let year = components.first,
              let month = components.dropFirst().first,
              let day = components.last else {
            return nil
        }
        
        let calendar = Calendar.current
        let currentDate = Date()
        
        guard let date = calendar.date(from: DateComponents(year: year, month: month, day: day)) else {
            return nil
        }
        
        // Excluir fechas menores a hoy
        if date < currentDate {
            return nil
        }
        
        return date
    }
    
}


extension String {
    var decoded: String {
        let attr = try? NSAttributedString(data: Data(utf8), options: [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ], documentAttributes: nil)
        
        return attr?.string ?? self
    }
}
