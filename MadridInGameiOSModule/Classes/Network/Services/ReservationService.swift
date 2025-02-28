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
}

struct IndividualReservationResponse: Codable {
    let data: [IndividualReservation]
}

struct IndividualReservation: Identifiable, Codable {
    let id: Int?
    let status: String?
    let slot: Slot
    let date: String
    let user: String?
    let team: String?
    let training: String?
    let qrImage: String?
    let qrValue: String?
    var times: [Time] = []
    var gamingSpaces: [GamingSpace] = []
    //let peripheralLoans: [Int]?
    
    enum CodingKeys: String, CodingKey {
        case id, status, slot, date, user, team, training, qrImage, qrValue, times
        //case peripheralLoans = "peripheral_loans"
    }
}

struct GamingSpaceResponseData: Codable {
    let data: [GamingSpace]
}

struct GamingSpace: Codable {
    let id: Int
    let translations: [Translation]
}

struct Translation: Codable {
    let description: String
    let device: String
    let gamingSpaceId: Int
    let id: Int
    let languagesCode: String

    enum CodingKeys: String, CodingKey {
        case description, device, id
        case gamingSpaceId = "gaming_space_id"
        case languagesCode = "languages_code"
    }
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
}

class ReservationService {

    func createReservation(reservation: Reservation, completion: @escaping (Result<ReserveResponse, Error>) -> Void) {
        
        // Configuramos el codificador para fechas
        let encoder = JSONEncoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Formato esperado para la fecha
        encoder.dateEncodingStrategy = .formatted(dateFormatter)

        // Creamos un diccionario con los datos de la reserva
        var reservationDict = [
            "status": reservation.status ?? "active",
            "slot": reservation.slot.id,
            "user": reservation.user ?? "",
            "date": dateFormatter.string(from: reservation.date),
            "peripheral_loans": reservation.peripheralLoans ?? [],
        ] as [String: Any]
        
        let timesMapped = reservation.times.map { ["gaming_space_times_id": ["id": $0.id]] }
        
        reservationDict["times"] = timesMapped
        
        Task {
                do {
                    let reserveResponseModel: ReserveResponseModel = try await DirectusService.shared.sendRequest(
                        endpoint: "gaming_space_reserves",
                        method: .POST,
                        body: reservationDict
                    )
                    if reserveResponseModel.data.id != 0 {
                        print("Reserva registrada con éxito: \(reserveResponseModel.data)")
                        completion(.success(reserveResponseModel.data))
                    } else {
                        print("Error: No se recibieron datos válidos.")
                        completion(.failure(NSError(domain: "com.example.error", code: 0, userInfo: [NSLocalizedDescriptionKey: "No se recibieron datos válidos."])))
                    }
                } catch {
                    print("Error al hacer un registro: \(error)")
                    completion(.failure(error))
                }
            }
    }
    
    func updateExistingReservation(reservationId: Int, qrImage: String, reservation: Reservation, completion: @escaping (Result<ReserveResponse, Error>) -> Void) {
        
        // Configurar el codificador para fechas
        let encoder = JSONEncoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Formato esperado para la fecha
        encoder.dateEncodingStrategy = .formatted(dateFormatter)

        // Crear el diccionario con los datos de la reserva
        var reservationDict: [String: Any] = [
            "qrImage": qrImage,
        ]
        
        let timesMapped = reservation.times.map { ["gaming_space_times_id": ["id": $0.id]] }
        reservationDict["times"] = timesMapped

        // Endpoint para actualizar la reserva específica
        let endpoint = "gaming_space_reserves/\(reservationId)"

        Task {
            do {
                let reserveResponseModel: ReserveResponseModel = try await DirectusService.shared.sendRequest(
                    endpoint: endpoint,
                    method: .PATCH,
                    body: reservationDict
                )
                
                if reserveResponseModel.data.id != 0 {
                    print("Reserva actualizada con éxito: \(reserveResponseModel.data)")
                    completion(.success(reserveResponseModel.data))
                } else {
                    print("Error: No se recibieron datos válidos.")
                    completion(.failure(NSError(domain: "com.example.error", code: 0, userInfo: [NSLocalizedDescriptionKey: "No se recibieron datos válidos."])))
                }
            } catch {
                print("Error al actualizar la reserva: \(error)")
                completion(.failure(error))
            }
        }
    }

    func getAllTrainnings(teamId: String, userId: String, completion: @escaping (Result<[EventModel], Error>) -> Void) {
        let parameters: [String: String] = [
            "fields": "id, status, start_date, time, players.users_id.id, players.users_id.avatar, players.users_id.email, players.users_id.first_name, type, reserves.*, reserves.team.name, reserves.team.picture, reserves.times.gaming_space_times_id.time, notes",
            "filter[team][_eq]": teamId,
        ]
        
        Task {
            do {
                let response: EventModelResponse = try await DirectusService.shared.request(
                    endpoint: "trainings",
                    method: .GET,
                    parameters: parameters
                )
                
                completion(.success(response.data))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func getReservesByUser(userId: String, completion: @escaping (Result<[IndividualReservation], Error>) -> Void) {
        let parameters: [String: String] = [
            "fields": "id, date, slot.*, qrImage, times.gaming_space_times_id.time",
            "filter[user][_eq]": userId,
            "filter[status][_neq]": "cancelled",
            "filter[date][_gte]": "$NOW",
            "filter[team][_null]": "true",
            "sort[]": "date"
        ]
        
        Task {
            do {
                let response: IndividualReservationResponse = try await DirectusService.shared.request(
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
    
    func getReservesSlotByUser(space: Int?, completion: @escaping (Result<[GamingSpace], Error>) -> Void) {
        let parameters: [String: String] = [
            "fields": "id, translations.*",
            "filter[id][_eq]": String(space ?? 0),
        ]
        
        Task {
            do {
                let response: GamingSpaceResponseData = try await DirectusService.shared.request(
                    endpoint: "gaming_space",
                    method: .GET,
                    parameters: parameters
                )
                
                completion(.success(response.data))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func getAllBlockedDays(completion: @escaping (Result<[BlockedDaysModel], Error>) -> Void) {
        
        let parameters: [String: String] = [
            "fields": "id, date, description"
        ]
        
        Task {
            do {
                let response: BlockedDaysModelResponse = try await DirectusService.shared.request(
                    endpoint: "gaming_space_blocked_days",
                    method: .GET,
                    parameters: parameters
                )
                
                completion(.success(response.data))
            } catch {
                completion(.failure(error))
            }
            
        }
    }
    
    func deleteReservation(id: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            do {
                // Realizamos la solicitud DELETE sin cuerpo
                try await DirectusService.shared.sendRequestWithoutDecode(
                    endpoint: "gaming_space_reserves/\(id)",
                    method: .DELETE,
                    body: [:]
                )
                
                // Llamamos a completion con un Success vacío si la operación es exitosa
                completion(.success(()))
            } catch {
                // Llamamos a completion con un Failure si ocurre un error
                print("Error al eliminar la reserva: \(error)")
                completion(.failure(error))
            }
        }
    }
}
