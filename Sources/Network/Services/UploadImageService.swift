//
//  UploadImageService.swift
//  Pods
//
//  Created by Arnau Rivas Rivas on 25/2/25.
//


import UIKit

class UploadImageService {
    
    let environmentManager = EnvironmentManager()
    
    func uploadImage(image: UIImage, fileName: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        let baseURL = "\(environmentManager.getBaseURL())/files"
        
        guard let url = URL(string: baseURL) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let accesToken = UserDefaults.getAccessTokenKey() ?? ""
        let token = "Bearer \(accesToken)"
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "Invalid Image", code: 500, userInfo: nil)))
            return
        }
        
        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data, let responseString = String(data: data, encoding: .utf8) else {
                completion(.failure(NSError(domain: "Invalid Response", code: 500, userInfo: nil)))
                return
            }
            
            completion(.success(responseString))
        }
        
        task.resume()
    }
}
