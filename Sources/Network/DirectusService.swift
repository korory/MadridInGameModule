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

extension NetworkError: LocalizedError {
    public var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidBody:
            return "Invalid Body"
        case .noData:
            return "No Data"
        case .invalidResponse:
            return "Invalid Response"
        case .encodingError:
            return "Encoding Error"
        case .decodingError:
            return "Decoding Error"
        }
    }
    
    public var errorDescription: String? {
        localizedDescription
    }
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
        
        Logger.shared.log("🛜 Endpoint request: \(url.absoluteString)")

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        let accesToken = UserDefaults.getAccessTokenKey() ?? ""
        let token = "Bearer \(accesToken)"
        request.setValue(token, forHTTPHeaderField: "Authorization")

        if let body = body {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
            
            if let jsonData = try? JSONSerialization.data(withJSONObject: body),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                Logger.shared.log("Cuerpo de la petición JSON: \(jsonString)")
            }
        }
        

        let (data, response) = try await URLSession.shared.data(for: request)

//        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
//            throw NetworkError.invalidResponse
//        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        if !(200...299).contains(httpResponse.statusCode) {
            let responseData = String(data: data, encoding: .utf8) ?? "No se pudo leer la respuesta"
            Logger.shared.log("Error HTTP: \(httpResponse.statusCode) - Respuesta: \(responseData)")
            throw NetworkError.invalidResponse
        }
        
        do {
            if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                Logger.shared.log("Datos JSON (sin decodificar): \(jsonResponse)")
            } else {
                Logger.shared.log("La respuesta no es un [String: Any]")
            }
        } catch {
            Logger.shared.log("Error al deserializar JSON: \(error.localizedDescription)")
        }


        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    // MARK: - Generic Send Function (POST, PATCH, PUT)
    public func sendRequest<T: Decodable>(
        endpoint: String,
        method: HTTPMethods,
        body: [String: Any]
    ) async throws -> T {
        return try await request(endpoint: endpoint, method: method, body: body)
    }
    

    public func request(
        endpoint: String,
        method: HTTPMethods,
        parameters: [String: Any] = [:],
        body: [String: Any] = [:]
    ) async throws -> Data? {
        // Construcción de la URL con los parámetros de la consulta (query parameters)
        guard let baseURL = environmentManager?.getBaseURL(), !baseURL.isEmpty else {
            throw NetworkError.invalidURL
        }
        
        var fullURLString = "\(baseURL)/items/\(endpoint)"

        var urlComponents = URLComponents(string: fullURLString)
        fullURLString = urlComponents?.url?.absoluteString ?? fullURLString
    
        
        if !parameters.isEmpty {
            urlComponents?.queryItems = parameters.map { key, value in
                URLQueryItem(name: key, value: "\(value)")
            }
        }
        
        // Crear la URL a partir de los componentes
        guard let url = urlComponents?.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        let accesToken = UserDefaults.getAccessTokenKey() ?? ""
        let token = "Bearer \(accesToken)"
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        // Agregar el cuerpo (body) si se necesita
        if !body.isEmpty {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        }
        
        // Realizar la solicitud y esperar la respuesta
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Verificar el código de estado de la respuesta (opcional)
        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            throw URLError(.badServerResponse)
        }
        
        // Retornar los datos sin decodificar
        return data
    }

    public func sendRequestWithoutDecode(
        endpoint: String,
        method: HTTPMethods,
        body: [String: Any]
    ) async throws {
        _ = try await request(endpoint: endpoint, method: method, body: body)
    }
    
    // MARK: - Trigger Flow (Webhook)
    public func triggerFlow(flowId: String, body: [String: Any]) async throws {
       guard let baseURL = environmentManager?.getBaseURL(), !baseURL.isEmpty else {
           throw NetworkError.invalidURL
       }

       let fullURLString = "\(baseURL)/flows/trigger/\(flowId)"

       guard let url = URL(string: fullURLString) else {
           throw NetworkError.invalidURL
       }

       Logger.shared.log("🛜 Flow trigger: \(url.absoluteString)")

       var request = URLRequest(url: url)
       request.httpMethod = HTTPMethods.POST.rawValue
       request.setValue("application/json", forHTTPHeaderField: "Content-Type")

       let accessToken = UserDefaults.getAccessTokenKey() ?? ""
       request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

       request.httpBody = try? JSONSerialization.data(withJSONObject: body)

       let (data, response) = try await URLSession.shared.data(for: request)

       guard let httpResponse = response as? HTTPURLResponse else {
           throw NetworkError.invalidResponse
       }

       if !(200...299).contains(httpResponse.statusCode) {
           let responseData = String(data: data, encoding: .utf8) ?? "No se pudo leer la respuesta"
           Logger.shared.log("Error HTTP flow trigger: \(httpResponse.statusCode) - \(responseData)")
           throw NetworkError.invalidResponse
       }

       Logger.shared.log("Flow trigger ejecutado correctamente")
   }
}


extension String {
    var urlQueryValueEncoded: String? {
        return addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)?
            .replacingOccurrences(of: "+", with: "%2B")
    }
}
