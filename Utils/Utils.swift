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

//extension Font {
//    static func customFont(size: CGFloat) -> Font {
//        return .custom("Madrid_in_game_font", size: size)
//    }
//}
