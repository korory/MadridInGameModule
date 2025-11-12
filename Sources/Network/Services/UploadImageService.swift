//
//  UploadImageService.swift
//  Pods
//
//  Created by Arnau Rivas Rivas on 25/2/25.
//


import UIKit

class UploadImageService {
    
    let environmentManager = EnvironmentManager()

    func uploadImage(image: UIImage, fileName: String, compressionQuality: CGFloat = 0.5, completion: @escaping (Result<String, Error>) -> Void) {
        let baseURLString = "\(environmentManager.getBaseURL())/files"
        guard let url = URL(string: baseURLString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }
        
        guard let accessToken = UserDefaults.getAccessTokenKey(), !accessToken.isEmpty else {
            completion(.failure(NSError(domain: "Missing Access Token", code: 401, userInfo: nil)))
            return
        }
        
        guard let imageData = image.jpegData(compressionQuality: compressionQuality) else {
            completion(.failure(NSError(domain: "Invalid Image", code: 500, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
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
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "Invalid Response", code: 500, userInfo: nil)))
                }
                return
            }
            
            guard 200..<300 ~= httpResponse.statusCode else {
                DispatchQueue.main.async {
                    let errorDescription = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
                    completion(.failure(NSError(domain: errorDescription, code: httpResponse.statusCode, userInfo: nil)))
                }
                return
            }
            
            guard let data = data, let responseString = String(data: data, encoding: .utf8) else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "Invalid Response Data", code: 500, userInfo: nil)))
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(responseString))
            }
        }
        
        task.resume()
    }

}
