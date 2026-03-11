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
    let description: String?
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


// MARK: - Nuevos modelos para Training

struct TrainingRequest {
    let status: String
    let type: String
    let startDate: String       // "yyyy-MM-dd"
    let time: String            // "HH:mm"
    let teamId: String
    let notes: String
    let playerIds: [String]     // IDs de usuarios
    let reserveId: Int          // ID de la gaming_space_reserve ya creada
}

struct TrainingResponseModel: Codable {
    let data: TrainingResponse
}

struct TrainingResponse: Codable {
    let id: String?
}

class ReservationService {
    
    func createReservation(reservation: Reservation, completion: @escaping (Result<ReserveResponse, Error>) -> Void) {
        
        let encoder = JSONEncoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        
        var reservationDict = [
            "status": reservation.status ?? "active",
            "slot": reservation.slot.id,
            "user": reservation.user ?? "",
            "date": dateFormatter.string(from: reservation.date),
            "peripheral_loans": reservation.peripheralLoans ?? [],
        ] as [String: Any]
        
        // Añade team solo si existe
        if let team = reservation.team {
            reservationDict["team"] = team
        }
        
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
                    Logger.shared.log("Reserva registrada con éxito: \(reserveResponseModel.data)")
                    completion(.success(reserveResponseModel.data))
                } else {
                    Logger.shared.log("Error: No se recibieron datos válidos.")
                    completion(.failure(NSError(domain: "com.example.error", code: 0, userInfo: [NSLocalizedDescriptionKey: "No se recibieron datos válidos."])))
                }
            } catch {
                Logger.shared.log("Error al hacer un registro: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func createTraining(request: TrainingRequest, completion: @escaping (Result<TrainingResponse, Error>) -> Void) {
        
        // Directus espera los players como array de objetos con la FK anidada
        let playersMapped = request.playerIds.map { ["users_id": $0] }
        
        // La reserva se enlaza como array de objetos con el ID
        let reservesMapped = [["id": request.reserveId]]
        
        let body: [String: Any] = [
            "status":     request.status,
            "type":       request.type,
            "start_date": request.startDate,
            "time":       request.time,
            "team":       request.teamId,
            "notes":      request.notes,
            "players":    playersMapped,
            "reserves":   reservesMapped
        ]
        
        Task {
            do {
                let response: TrainingResponseModel = try await DirectusService.shared.sendRequest(
                    endpoint: "trainings",
                    method: .POST,
                    body: body
                )
                Logger.shared.log("Training creado con éxito: \(response.data)")
                completion(.success(response.data))
            } catch {
                Logger.shared.log("Error al crear el training: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func updateExistingReserveForTeam(
        reserveId: Int,
        date: Date,
        slot: Slot,
        times: [GamingSpaceTime],
        completion: @escaping (Result<ReserveResponse, Error>) -> Void
    ) {
        let dateFmt = DateFormatter()
        dateFmt.dateFormat = "yyyy-MM-dd"

        let timesMapped = times.map { ["gaming_space_times_id": ["id": $0.id]] }

        let body: [String: Any] = [
            "date":  dateFmt.string(from: date),
            "slot":  slot.id,
            "times": timesMapped
        ]

        Task {
            do {
                let response: ReserveResponseModel = try await DirectusService.shared.sendRequest(
                    endpoint: "gaming_space_reserves/\(reserveId)",
                    method: .PATCH,
                    body: body
                )
                completion(.success(response.data))
            } catch {
                Logger.shared.log("Error al actualizar reserve de equipo: \(error)")
                completion(.failure(error))
            }
        }
    }

    func updateTraining(
        trainingId: String,
        type: String,
        startDate: String,
        time: String,
        notes: String,
        playerIds: [String],
        completion: @escaping (Result<TrainingResponse, Error>) -> Void
    ) {
        let playersMapped = playerIds.map { ["users_id": $0] }

        let body: [String: Any] = [
            "type":       type,
            "start_date": startDate,
            "time":       time,
            "notes":      notes,
            "players":    playersMapped
        ]

        Task {
            do {
                let response: TrainingResponseModel = try await DirectusService.shared.sendRequest(
                    endpoint: "trainings/\(trainingId)",
                    method: .PATCH,
                    body: body
                )
                Logger.shared.log("Training actualizado con éxito: \(response.data)")
                completion(.success(response.data))
            } catch {
                Logger.shared.log("Error al actualizar el training: \(error)")
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
                    Logger.shared.log("Reserva actualizada con éxito: \(reserveResponseModel.data)")
                    completion(.success(reserveResponseModel.data))
                } else {
                    Logger.shared.log("Error: No se recibieron datos válidos.")
                    completion(.failure(NSError(domain: "com.example.error", code: 0, userInfo: [NSLocalizedDescriptionKey: "No se recibieron datos válidos."])))
                }
            } catch {
                Logger.shared.log("Error al actualizar la reserva: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func getAllTrainings(teamId: String, userId: String, completion: @escaping (Result<[EventModel], Error>) -> Void) {
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
            "fields": "id, date, slot.*,qrImage,qrValue,times.gaming_space_times_id.time",
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
            "fields": "id, date, description",
            "filter[date][_gte]": Date().toServerDateString()
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
    
    //    func deleteReservation(id: Int, completion: @escaping (Result<Void, Error>) -> Void) {
    //        Task {
    //            do {
    //                // Realizamos la solicitud DELETE sin cuerpo
    //                try await DirectusService.shared.sendRequestWithoutDecode(
    //                    endpoint: "gaming_space_reserves/\(id)",
    //                    method: .DELETE,
    //                    body: [:]
    //                )
    //
    //                // Llamamos a completion con un Success vacío si la operación es exitosa
    //                completion(.success(()))
    //            } catch {
    //                // Llamamos a completion con un Failure si ocurre un error
    //                Logger.shared.log("Error al eliminar la reserva: \(error)")
    //                completion(.failure(error))
    //            }
    //        }
    //    }
    
    func deleteReservation(id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            do {
                try await DirectusService.shared.sendRequestWithoutDecode(
                    endpoint: "gaming_space_reserves/\(id)",
                    method: .DELETE,
                    body: [:]
                )
                completion(.success(()))
            } catch {
                Logger.shared.log("Error al eliminar la reserva: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func deleteTraining(
        trainingId: String,
        reserveId: Int?,             // nil si es virtual
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        Task {
            do {
                // Siempre borramos el training
                try await DirectusService.shared.sendRequestWithoutDecode(
                    endpoint: "trainings/\(trainingId)",
                    method: .DELETE,
                    body: [:]
                )

                // Solo borramos la reserve si existe (tipo centre)
                if let reserveId {
                    try await DirectusService.shared.sendRequestWithoutDecode(
                        endpoint: "gaming_space_reserves/\(reserveId)",
                        method: .DELETE,
                        body: [:]
                    )
                }

                completion(.success(()))
            } catch {
                Logger.shared.log("Error al eliminar el training: \(error)")
                completion(.failure(error))
            }
        }
    }
}
