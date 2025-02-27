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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Formato solo con la fecha
        let dateString1 = dateFormatter.string(from: currentDate)
        
        guard let date = calendar.date(from: DateComponents(year: year, month: month, day: day)) else {
            return nil
        }
        
        // Excluir fechas menores a hoy
        if dateString < dateString1 {
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

extension UserDefaults {
    private static let logoMIGKey = "logoMIGKey"
    private static let qrMiddleLogo = "qrMiddleLogo"

    static func saveLogoMIG(_ image: UIImage) {
        if let data = image.pngData() {
            UserDefaults.standard.set(data, forKey: logoMIGKey)
        }
    }
    
    static func getLogoMIG() -> UIImage? {
        if let data = UserDefaults.standard.data(forKey: logoMIGKey) {
            return UIImage(data: data)
        }
        return nil
    }
    
    static func saveQrMiddleLogo(_ image: UIImage) {
        if let data = image.pngData() {
            UserDefaults.standard.set(data, forKey: qrMiddleLogo)
        }
    }
    
    static func getQRMiddleLogo() -> UIImage? {
        if let data = UserDefaults.standard.data(forKey: qrMiddleLogo) {
            return UIImage(data: data)
        }
        return nil
    }
}

