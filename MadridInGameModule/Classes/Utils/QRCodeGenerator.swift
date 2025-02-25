//
//  QRCodeGenerator.swift
//  Pods
//
//  Created by Arnau Rivas Rivas on 25/2/25.
//


import SwiftUI
import CoreImage.CIFilterBuiltins

class QRCodeGenerator {
    static func generateQRCode(with text: String, size: CGSize = CGSize(width: 200, height: 200)) -> UIImage? {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        
        let data = Data(text.utf8)
        filter.setValue(data, forKey: "inputMessage")
        
        guard let qrCodeImage = filter.outputImage else { return nil }
        let transformedImage = qrCodeImage.transformed(by: CGAffineTransform(scaleX: size.width / qrCodeImage.extent.width, 
                                                                             y: size.height / qrCodeImage.extent.height))
        
        guard let cgImage = context.createCGImage(transformedImage, from: transformedImage.extent) else { return nil }
        var finalImage = UIImage(cgImage: cgImage)
        
        if let logo = UserDefaults.getQRMiddleLogo() {
            finalImage = addLogo(to: finalImage, logo: logo)
        }
        
        return finalImage
    }
    
    private static func addLogo(to qrCode: UIImage, logo: UIImage) -> UIImage {
        let size = qrCode.size
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        qrCode.draw(in: CGRect(origin: .zero, size: size))
        
        let logoSize = CGSize(width: size.width * 0.2, height: size.height * 0.2)
        let logoOrigin = CGPoint(x: (size.width - logoSize.width) / 2, y: (size.height - logoSize.height) / 2)
        logo.draw(in: CGRect(origin: logoOrigin, size: logoSize))
        
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return finalImage ?? qrCode
    }
}
