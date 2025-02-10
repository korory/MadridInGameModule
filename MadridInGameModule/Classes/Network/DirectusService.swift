//
//  DirectusService.swift
//  Pods
//
//  Created by Arnau Rivas Rivas on 4/2/25.
//

import Foundation
import SwiftUI

enum NetworkError: Error {
    case invalidURL
    case invalidBody
    case noData
    case invalidResponse
    case encodingError
    case decodingError
}

enum HTTPMethods: String {
    case GET
    case POST
    case PUT
    case PATCH
    case DELETE
    case HEAD
    case OPTIONS
}

actor DirectusService {
    // MARK: - Singleton Instance
    public static let shared = DirectusService()
    private init() {}

    // MARK: - Environment Manager
    private var environmentManager: EnvironmentManager?

    // MARK: - Setup Method
    public func configure(with environmentManager: EnvironmentManager) {
        self.environmentManager = environmentManager
    }

    // MARK: - Generic Fetch Function
    public func request<T: Decodable>(endpoint: String, method: HTTPMethods, parameters: [String: String]? = nil, body: [String: Any]? = nil) async throws -> T {
        guard let baseURL = environmentManager?.getBaseURL(), !baseURL.isEmpty else {
            throw NetworkError.invalidURL
        }

        var fullURLString = "\(baseURL)/items/\(endpoint)"
        if let parameters = parameters, !parameters.isEmpty {
            let queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
            var urlComponents = URLComponents(string: fullURLString)
            urlComponents?.queryItems = queryItems
            fullURLString = urlComponents?.url?.absoluteString ?? fullURLString
        }

        guard let url = URL(string: fullURLString) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        let token = "Bearer 8TZMs1jYI1xIts2uyUnE_MJrPQG9KHfY"
        request.setValue(token, forHTTPHeaderField: "Authorization")

        if let body = body {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
        do {
            if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                print("Datos JSON (sin decodificar): \(jsonResponse)")
            } else {
                print("La respuesta no es un [String: Any]")
            }
        } catch {
            print("Error al deserializar JSON: \(error.localizedDescription)")
        }


        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }
}
