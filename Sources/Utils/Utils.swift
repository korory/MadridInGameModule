//
//  Utils.swift
//  Pods
//
//  Created by Arnau Rivas Rivas on 4/2/25.
//


import Foundation
import SwiftUI

class Utils {
    static func createDate(from dateString: String, with format: String = "yyyy-MM-dd") -> Date? {
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
        dateFormatter.dateFormat = format // Formato solo con la fecha
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
    private enum Constants {
        static let accessTokenKey = "accessTokenKey"
        static let logoMIGKey = "logoMIGKey"
        static let qrMiddleLogo = "qrMiddleLogo"
    }

    static func saveAccessTokenKey(_ accessToken: String) {
        UserDefaults.standard.set(accessToken, forKey: Constants.accessTokenKey)
    }
    
    static func getAccessTokenKey() -> String? {
        return UserDefaults.standard.string(forKey: Constants.accessTokenKey)
    }
    
    static func saveLogoMIG(_ image: UIImage) {
        if let data = image.pngData() {
            UserDefaults.standard.set(data, forKey: Constants.logoMIGKey)
        }
    }
    
    static func getLogoMIG() -> UIImage? {
        if let data = UserDefaults.standard.data(forKey: Constants.logoMIGKey) {
            return UIImage(data: data)
        }
        return nil
    }
    
    static func saveQrMiddleLogo(_ image: UIImage) {
        if let data = image.pngData() {
            UserDefaults.standard.set(data, forKey: Constants.qrMiddleLogo)
        }
    }
    
    static func getQRMiddleLogo() -> UIImage? {
        if let data = UserDefaults.standard.data(forKey: Constants.qrMiddleLogo) {
            return UIImage(data: data)
        }
        return nil
    }
}

extension Date {
    var isInCurrentYear: Bool {
           let calendar = Calendar.current
           return calendar.component(.year, from: self) == calendar.component(.year, from: Date())
       }
    
    func toServerDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.string(from: self)
    }
    
    func toUIDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = Locale.current
        return formatter.string(from: self)
    }
    
    static func dateFromString(date: String, with format: String = "yyyy-MM-dd") -> Date? {
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale.current
        inputFormatter.dateFormat = format
        return inputFormatter.date(from: date)
    }
}

extension Bundle {
    static var podBundle: Bundle? = {
        let podBundle = Bundle(for: MadridInGameiOSViewModel.self)
        if let url = podBundle.url(forResource: "MadridInGameiOSModule", withExtension: "bundle") {
            return Bundle(url: url)
        }
        return nil
    }()
}

extension String {
    var localized: String {
        return NSLocalizedString(self, bundle: Bundle.podBundle ?? .main, comment: "\(self)_comment")
    }

    func localized(_ args: [CVarArg]) -> String {
        return String(format: localized, args)
    }

    func localized(_ args: CVarArg...) -> String {
        return String(format: localized, args)
    }
}

extension Font {
    static func madridInGameiOSFont(size: CGFloat) -> Font {
        return Font.custom("Madridingamefont-Regular", size: size)
    }
}

extension UIImage {
    func resized(with maxSize: CGFloat) -> UIImage {
        let maxDimension: CGFloat = maxSize
        let aspectRatio = size.width / size.height
        
        var newSize: CGSize
        if size.width > size.height {
            newSize = CGSize(width: maxDimension, height: maxDimension / aspectRatio)
        } else {
            newSize = CGSize(width: maxDimension * aspectRatio, height: maxDimension)
        }
        
        if size.width <= maxDimension && size.height <= maxDimension {
            return self
        }
        
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let resizedImage = renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
        return resizedImage
    }
}
