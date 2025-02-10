//
//  ReservationService.swift
//  MadridInGameModule
//
//  Created by Hamza El Hamdaoui on 23/1/25.
//

import Foundation

struct TeamReservationResponse: Codable {
    let data: [TeamReservation]
}

struct TeamReservation: Codable, Identifiable {
    let id: Int
    let date: Date
    let slot: Slot
    let times: [GamingSpaceTime]
    
    enum CodingKeys: String, CodingKey {
        case id, date, slot, times
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        slot = try container.decode(Slot.self, forKey: .slot)
        
        // Decodificar y convertir `date`
        let dateString = try container.decode(String.self, forKey: .date)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let parsedDate = formatter.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(forKey: .date, in: container, debugDescription: "Invalid date format")
        }
        date = parsedDate
        
        let timesContainer = try container.decode([[String: GamingSpaceTime]].self, forKey: .times)
        times = timesContainer.compactMap { $0["gaming_space_times_id"] }
    }
}

struct ReservationResponse: Codable {
    let data: [Reservation]
}

struct Reservation: Codable {
    let id: Int?
    let status: String?
    let slot: Slot
    let date: Date
    let user: String?
    let team: String?
    let training: String?
    let qrImage: String?
    let qrValue: String?
    var times: [GamingSpaceTime]
    let peripheralLoans: [Int]?
    
    enum CodingKeys: String, CodingKey {
        case id, status, slot, date, user, team, training, qrImage, qrValue, times
        case peripheralLoans = "peripheral_loans"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        status = try container.decodeIfPresent(String.self, forKey: .status)
        slot = try container.decode(Slot.self, forKey: .slot)
        user = try container.decodeIfPresent(String.self, forKey: .user)
        team = try container.decodeIfPresent(String.self, forKey: .team)
        training = try container.decodeIfPresent(String.self, forKey: .training)
        qrImage = try container.decodeIfPresent(String.self, forKey: .qrImage)
        qrValue = try container.decodeIfPresent(String.self, forKey: .qrValue)
        //times = try container.decode([GamingSpaceTime].self, forKey: .times)
        peripheralLoans = try container.decodeIfPresent([Int].self, forKey: .peripheralLoans)
        
        let dateString = try container.decode(String.self, forKey: .date)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let parsedDate = formatter.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(forKey: .date, in: container, debugDescription: "Formato de fecha inválido")
        }
        date = parsedDate
        
        let timesContainer = try container.decode([[String: GamingSpaceTime]].self, forKey: .times)
                times = timesContainer.compactMap { $0["gaming_space_times_id"] }
    }
    
    init(
        id: Int,
        status: String? = nil,
        slot: Slot,
        date: Date,
        user: String? = nil,
        team: String? = nil,
        training: String? = nil,
        qrImage: String? = nil,
        qrValue: String? = nil,
        times: [GamingSpaceTime] = [],
        peripheralLoans: [Int] = []
    ) {
        self.id = id
        self.status = status
        self.slot = slot
        self.date = date
        self.user = user
        self.team = team
        self.training = training
        self.qrImage = qrImage
        self.qrValue = qrValue
        self.times = times
        self.peripheralLoans = peripheralLoans
    }
    
}

class ReservationService {
    private let baseURL = URL(string: "https://premig.randomkesports.com/cms/items/gaming_space_reserves")!
    private let token = "Bearer 8TZMs1jYI1xIts2uyUnE_MJrPQG9KHfY"
    
    func createReservation(reservation: Reservation, completion: @escaping (Result<Void, Error>) -> Void) {
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        do {
            // Configuramos el codificador para fechas
            let encoder = JSONEncoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd" // Formato esperado para la fecha
            encoder.dateEncodingStrategy = .formatted(dateFormatter)
            
            // Creamos un diccionario con los datos de la reserva
            var reservationDict = [
                //"status": reservation.status ?? "active",
                "slot": reservation.slot.id,
                "user": reservation.user ?? "",
                "date": dateFormatter.string(from: reservation.date),
                "peripheral_loans": reservation.peripheralLoans ?? []
            ] as [String: Any]
            
            // Mapear los tiempos al formato esperado
            let timesMapped = reservation.times.map { ["gaming_space_times_id": ["id": $0.id]] }
            reservationDict["times"] = timesMapped
            
            reservationDict.removeValue(forKey: "id")
            
            // Convertimos el diccionario a JSON Data
            let jsonData = try JSONSerialization.data(withJSONObject: reservationDict, options: [])
            request.httpBody = jsonData
            
            // Realizamos la solicitud al backend
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    completion(.failure(NSError(domain: "Invalid Response", code: 0, userInfo: nil)))
                    return
                }
                
                completion(.success(()))
            }
            task.resume()
        } catch {
            completion(.failure(error))
        }
    }
    
//    func getReservations(completion: @escaping (Result<[Reservation], Error>) -> Void) {
//        guard let url = URL(string: "https://premig.randomkesports.com/cms/items/gaming_space_reserves") else { return }
//        
//        /*var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
//         components.queryItems = [
//         URLQueryItem(name: "fields", value: "id,status,slot,date,user,times"),
//         URLQueryItem(name: "filter[status][_neq]", value: "cancelled"),
//         URLQueryItem(name: "filter[date][_gte]", value: "$NOW") // Reservas futuras
//         ]
//         
//         var request = URLRequest(url: components.url!)*/
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.setValue(token, forHTTPHeaderField: "Authorization")
//        
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            
//            guard let data = data else {
//                completion(.failure(NSError(domain: "No Data", code: 0, userInfo: nil)))
//                return
//            }
//            
//            do {
//                let decodedResponse = try JSONDecoder().decode(ReservationResponse.self, from: data)
//                completion(.success(decodedResponse.data))
//            } catch {
//                completion(.failure(error))
//            }
//        }
//        task.resume()
//    }
//
    
    func getReservesByTeam(teamId: String, completion: @escaping (Result<[TeamReservation], Error>) -> Void) {
        let parameters: [String: String] = [
            "fields": "id,date,slot.*,times.gaming_space_times_id.time,times.gaming_space_times_id.id,times.gaming_space_times_id.value",
            "filter[team][_eq]": teamId,
            "filter[status][_neq]": "cancelled",
            "sort[]": "date"
        ]
        
        Task {
            do {
                let response: TeamReservationResponse = try await DirectusService.shared.request(
                    endpoint: "gaming_space_reserves",
                    method: .GET,
                    parameters: parameters
                )
                
                completion(.success(response.data))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func getReservesByTeamAndUser(teamId: String, userId: String, completion: @escaping (Result<[TeamReservation], Error>) -> Void) {
        let parameters: [String: String] = [
            "fields": "id,date,slot.*,times.gaming_space_times_id.time,times.gaming_space_times_id.id,times.gaming_space_times_id.value",
            "filter[team][_eq]": teamId,
            "filter[status][_neq]": "cancelled",
            "filter[user][_eq]": userId,
            "sort[]": "date"
        ]
        
        Task {
            do {
                let response: TeamReservationResponse = try await DirectusService.shared.request(
                    endpoint: "gaming_space_reserves",
                    method: .GET,
                    parameters: parameters
                )
                
                completion(.success(response.data))
            } catch {
                completion(.failure(error))
            }
        }
    }

    func getReservesByUser(userId: String, completion: @escaping (Result<[Reservation], Error>) -> Void) {
        let parameters: [String: String] = [
            "fields": "id,date,slot.*,qrImage,times.gaming_space_times_id.time,times.gaming_space_times_id.id,times.gaming_space_times_id.value",
            "filter[user][_eq]": userId,
            "filter[status][_neq]": "cancelled",
            "filter[date][_gte]": "$NOW",
            "filter[team][_null]": "true",
            "sort[]": "date"
        ]
        
        Task {
            do {
                let response: ReservationResponse = try await DirectusService.shared.request(
                    endpoint: "gaming_space_reserves",
                    method: .GET,
                    parameters: parameters
                )
                
                completion(.success(response.data))
            } catch {
                completion(.failure(error))
            }
        }
    }

    
//    func getReservesByTeam1(teamId: String, completion: @escaping (Result<[TeamReservation], Error>) -> Void) {
//        
//        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!
//        components.queryItems = [
//            URLQueryItem(name: "fields", value: "id,date,slot.*,times.gaming_space_times_id.time,times.gaming_space_times_id.id,times.gaming_space_times_id.value"),
//            URLQueryItem(name: "filter[team][_eq]", value: teamId),
//            URLQueryItem(name: "filter[status][_neq]", value: "cancelled"),
//            //URLQueryItem(name: "filter[date][_gte]", value: "$NOW"),
//            URLQueryItem(name: "sort[]", value: "date")
//        ]
//        
//        var request = URLRequest(url: components.url!)
//        request.httpMethod = "GET"
//        request.setValue(token, forHTTPHeaderField: "Authorization")
//        
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            
//            guard let data = data else {
//                completion(.failure(NSError(domain: "No Data", code: 0, userInfo: nil)))
//                return
//            }
//            
//            do {
//                let decoder = JSONDecoder()
//                let decodedResponse = try decoder.decode(TeamReservationResponse.self, from: data)
//                completion(.success(decodedResponse.data))
//            } catch {
//                completion(.failure(error))
//            }
//        }
//        task.resume()
//    }
    
//    func getReservesByTeamAndUser(teamId: String, userId: String, completion: @escaping (Result<[TeamReservation], Error>) -> Void) {
//        
//        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!
//        components.queryItems = [
//            URLQueryItem(name: "fields", value: "id,date,slot.*,times.gaming_space_times_id.time,times.gaming_space_times_id.id,times.gaming_space_times_id.value"),
//            URLQueryItem(name: "filter[team][_eq]", value: teamId),
//            URLQueryItem(name: "filter[status][_neq]", value: "cancelled"),
//            URLQueryItem(name: "filter[user][_eq]", value: userId),
//            //URLQueryItem(name: "filter[date][_gte]", value: "$NOW"),
//            URLQueryItem(name: "sort[]", value: "date")
//        ]
//        
//        var request = URLRequest(url: components.url!)
//        request.httpMethod = "GET"
//        request.setValue(token, forHTTPHeaderField: "Authorization")
//        
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            
//            guard let data = data else {
//                completion(.failure(NSError(domain: "No Data", code: 0, userInfo: nil)))
//                return
//            }
//            
//            do {
//                let decoder = JSONDecoder()
//                let decodedResponse = try decoder.decode(TeamReservationResponse.self, from: data)
//                completion(.success(decodedResponse.data))
//            } catch {
//                completion(.failure(error))
//            }
//        }
//        task.resume()
//    }
//    
//    func getReservesByUser(userId: String, completion: @escaping (Result<[Reservation], Error>) -> Void) {
//        let url = baseURL
//        
//        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
//        components.queryItems = [
//            URLQueryItem(name: "fields", value: "id,date,slot.*,qrImage,times.gaming_space_times_id.time,times.gaming_space_times_id.id,times.gaming_space_times_id.value"),
//            URLQueryItem(name: "filter[user][_eq]", value: userId),
//            URLQueryItem(name: "filter[status][_neq]", value: "cancelled"),
//            URLQueryItem(name: "filter[date][_gte]", value: "$NOW"),
//            URLQueryItem(name: "filter[team][_null]", value: "true"),
//            URLQueryItem(name: "sort[]", value: "date")
//        ]
//        
//        var request = URLRequest(url: components.url!)
//        request.httpMethod = "GET"
//        request.setValue(token, forHTTPHeaderField: "Authorization")
//        
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            
//            guard let data = data else {
//                completion(.failure(NSError(domain: "No Data", code: 0, userInfo: nil)))
//                return
//            }
//            
//            do {
//                let decodedResponse = try JSONDecoder().decode(ReservationResponse.self, from: data)
//                completion(.success(decodedResponse.data))
//            } catch {
//                completion(.failure(error))
//            }
//        }
//        task.resume()
//    }
    
    func deleteReservation(id: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        let deleteURL = baseURL.appendingPathComponent("\(id)")
        var request = URLRequest(url: deleteURL)
        request.httpMethod = "DELETE"
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "Invalid Response", code: 0, userInfo: nil)))
                return
            }
            
            completion(.success(()))
        }
        task.resume()
    }
    
}

