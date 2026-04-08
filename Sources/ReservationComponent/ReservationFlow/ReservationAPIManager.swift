//
//  ReservationAPIManager.swift
//  Pods
//
//  Created by Arnau Rivas Rivas on 18/3/26.
//


import SwiftUI

class ReservationAPIManager {

    private let reservationService = ReservationService()
    private let userManager = UserManager.shared

    // MARK: - Flow IDs (email)

    private var isPro: Bool {
        UserDefaults.standard.value(forKey: "selectedEnvironment") as? Bool ?? true
    }

    // MARK: - Fetch datos iniciales

    func fetchBlockedDays(completion: @escaping (Result<[MarkTrainingDatesAndReservations], Error>) -> Void) {
        reservationService.getAllBlockedDays { result in
            switch result {
            case .success(let blockedDays):
                let marked = blockedDays
                    .compactMap { $0.date.flatMap { Utils.createDate(from: $0) } }
                    .map { MarkTrainingDatesAndReservations(date: $0, blockedDays: true) }
                completion(.success(marked))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchUserReservations(userId: String, completion: @escaping (Result<[MarkTrainingDatesAndReservations], Error>) -> Void) {
        reservationService.getReservesByUser(userId: userId) { result in
            switch result {
            case .success(let reservations):
                let marked = reservations
                    .compactMap { Utils.createDate(from: $0.date) }
                    .map { MarkTrainingDatesAndReservations(date: $0, individualReservation: true) }
                completion(.success(marked))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchTeamTrainings(teamId: String, userId: String, completion: @escaping (Result<[MarkTrainingDatesAndReservations], Error>) -> Void) {
        reservationService.getAllTrainings(teamId: teamId, userId: userId) { result in
            switch result {
            case .success(let trainings):
                let marked = trainings.compactMap { training -> MarkTrainingDatesAndReservations? in
                    guard let date = Utils.createDate(from: training.startDate) else { return nil }
                    return MarkTrainingDatesAndReservations(date: date, individualReservation: false)
                }
                completion(.success(marked))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - Fetch espacios y slots

    func fetchSpaces(isPersonal: Bool, completion: @escaping (Result<[Space], Error>) -> Void) {
        SpaceService.shared.fetchSpaces { result in
            switch result {
            case .success(let spaces):
                var mapped: [Space] = []
                for space in spaces {
                    guard let t = space.translations.first(where: { $0.languagesCode == "es" }) else { continue }
                    if !isPersonal && t.device.lowercased().contains("simulador") { continue }
                    mapped.append(Space(id: UUID().hashValue, device: t.device, description: t.description ?? "", slots: space.slots, type: ""))
                }
                completion(.success(mapped))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchSlots(dayValue: Int, isSimulator: Bool, completion: @escaping (Result<[GamingSpaceTime], Error>) -> Void) {
        WeekTimeService.shared.fetchWeekTimeByDay(dayValue: dayValue) { result in
            switch result {
            case .success(let slots):
                var newSlots: [GamingSpaceTime] = []
                for slot in slots { for time in slot.times { newSlots.append(time.gamingSpaceTime) } }
                let fmt = DateFormatter()
                fmt.dateFormat = "HH:mm"
                fmt.locale = Locale(identifier: "es_ES")
                let sorted = newSlots.sorted {
                    guard let d1 = fmt.date(from: $0.time), let d2 = fmt.date(from: $1.time) else { return false }
                    return d1 < d2
                }
                let filtered = isSimulator ? sorted : sorted.filter { !$0.time.hasSuffix(":30") }
                completion(.success(filtered))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - Ocupación de slots

    /// Returns which time IDs are fully booked (all physical slots occupied) AND a per-slot occupancy map.
    /// - perSlot: [slotId: Set<timeId>] — which times each slot has booked
    func fetchOccupiedTimeIds(space: Space, date: Date, completion: @escaping (Set<Int>, [Int: Set<Int>]) -> Void) {
        let slotIds = space.slots.map { $0.id }
        guard !slotIds.isEmpty else { completion([], [:]); return }

        let dateFmt = DateFormatter()
        dateFmt.dateFormat = "yyyy-MM-dd"
        let dateString = dateFmt.string(from: date)
        let totalSlots = slotIds.count

        reservationService.getReservationsBySlots(slotIds: slotIds, date: dateString) { result in
            switch result {
            case .success(let entries):
                var slotsPerTime: [Int: Set<Int>] = [:]
                var perSlotMap: [Int: Set<Int>] = [:]
                for entry in entries {
                    for timeId in entry.timeIds {
                        slotsPerTime[timeId, default: []].insert(entry.slotId)
                    }
                    perSlotMap[entry.slotId, default: []].formUnion(entry.timeIds)
                }
                // A time is fully occupied when ALL physical slots are booked at that time
                let occupied = Set(slotsPerTime.compactMap { timeId, slots -> Int? in
                    slots.count >= totalSlots ? timeId : nil
                })
                completion(occupied, perSlotMap)
            case .failure:
                // On error, don't block any slots — fail open
                completion([], [:])
            }
        }
    }

    // MARK: - Crear reserva individual + QR

    func createIndividualReservation(
        date: Date,
        slot: Slot,
        userId: String,
        teamId: String?,
        times: [GamingSpaceTime],
        completion: @escaping (Result<ReserveResponse, Error>) -> Void
    ) {
        let reservation = Reservation(
            id: 0, status: "active",
            slot: slot, date: date, user: userId, team: teamId,
            training: nil, qrImage: nil, qrValue: nil,
            times: times, peripheralLoans: []
        )
        reservationService.createReservation(reservation: reservation, completion: completion)
    }

    func uploadQRAndUpdateReservation(
        reservationInfo: ReserveResponse,
        times: [GamingSpaceTime],
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        guard let reservationId = reservationInfo.id,
              let qrValue = reservationInfo.qrValue,
              let qrImage = QRCodeGenerator.generateQRCode(with: qrValue) else {
            completion(.failure(NSError(domain: "QR", code: 0, userInfo: [NSLocalizedDescriptionKey: "Datos incompletos para QR"])))
            return
        }

        UploadImageService().uploadImage(image: qrImage, fileName: "\(qrValue).jpg") { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                guard let data = response.data(using: .utf8),
                      let decoded = try? JSONDecoder().decode(SendImageResponse.self, from: data) else {
                    completion(.failure(NSError(domain: "QR", code: 1, userInfo: [NSLocalizedDescriptionKey: "Error decodificando imagen"])))
                    return
                }
                let fileId = decoded.data.id
                let reservation = Reservation(
                    id: reservationId, status: "active",
                    slot: Slot(id: 0, position: "", space: 0),
                    date: Date(), user: nil, team: nil,
                    training: nil, qrImage: fileId, qrValue: qrValue,
                    times: times, peripheralLoans: []
                )
                self.reservationService.updateExistingReservation(reservationId: reservationId, qrImage: fileId, reservation: reservation) { result in
                    switch result {
                    case .success: completion(.success(()))
                    case .failure(let error): completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - Crear reserva add-on (simulador o espacio extra)

    func createAddonReservation(
        date: Date,
        userId: String,
        addonSlot: Slot,
        addonTimes: [GamingSpaceTime],
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let dateFmt = DateFormatter()
        dateFmt.dateFormat = "yyyy-MM-dd"

        let body: [String: Any] = [
            "date": dateFmt.string(from: date),
            "user": userId,
            "slot": addonSlot.id,
            "times": addonTimes.map { ["gaming_space_times_id": ["id": $0.id]] }
        ]

        Task {
            do {
                let response: ReserveResponseModel = try await DirectusService.shared.sendRequest(
                    endpoint: "gaming_space_reserves",
                    method: .POST,
                    body: body
                )
                await MainActor.run {
                    self.uploadQRAndUpdateReservation(reservationInfo: response.data, times: addonTimes) { result in
                        switch result {
                        case .success: completion(.success(()))
                        case .failure(let error): completion(.failure(error))
                        }
                    }
                }
            } catch {
                await MainActor.run {
                    completion(.failure(error))
                }
            }
        }
    }

    // MARK: - Actualizar reserva individual (edición)

    func updateIndividualReservation(
        reservationId: Int,
        date: Date,
        slot: Slot,
        times: [GamingSpaceTime],
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let dateFmt = DateFormatter()
        dateFmt.dateFormat = "yyyy-MM-dd"

        let body: [String: Any] = [
            "date": dateFmt.string(from: date),
            "slot": slot.id,
            "times": times.map { ["gaming_space_times_id": ["id": $0.id]] }
        ]

        Task {
            do {
                let _: ReserveResponseModel = try await DirectusService.shared.sendRequest(
                    endpoint: "gaming_space_reserves/\(reservationId)",
                    method: .PATCH,
                    body: body
                )
                await MainActor.run { completion(.success(())) }
            } catch {
                await MainActor.run { completion(.failure(error)) }
            }
        }
    }

    // MARK: - Crear training de equipo (centre)

    func createTeamTraining(
        date: Date,
        space: Space,
        teamId: String,
        notes: String,
        spaceType: String,
        time: String,
        players: [(id: String, email: String, name: String)],
        selectedSlots: [GamingSpaceTime],
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let dateFmt = DateFormatter()
        dateFmt.dateFormat = "yyyy-MM-dd"
        let dateString = dateFmt.string(from: date)
        let slotToUse = space.slots.first ?? Slot(id: 0, position: "", space: 0)
        let playerIds = players.map { $0.id }

        let trainingRequest = TrainingRequest(
            status: "active", type: spaceType,
            startDate: dateString, time: time,
            teamId: teamId, notes: notes,
            playerIds: playerIds, reserveIds: []
        )

        reservationService.createTraining(request: trainingRequest) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let trainingResponse):
                guard let trainingId = trainingResponse.id else {
                    completion(.failure(NSError(domain: "Training", code: 0, userInfo: [NSLocalizedDescriptionKey: "No training ID"])))
                    return
                }

                let group = DispatchGroup()
                var reserveIds: [Int] = []
                var hasError = false

                for player in players {
                    group.enter()
                    let reservation = Reservation(
                        id: 0, status: "active", slot: slotToUse,
                        date: date, user: player.id, team: teamId,
                        training: trainingId, qrImage: nil, qrValue: nil,
                        times: selectedSlots, peripheralLoans: []
                    )

                    self.reservationService.createReservation(reservation: reservation) { [weak self] result in
                        guard let self else { group.leave(); return }
                        switch result {
                        case .success(let reserveResponse):
                            guard let reserveId = reserveResponse.id else {
                                hasError = true; group.leave(); return
                            }
                            reserveIds.append(reserveId)
                            self.uploadQRAndUpdateReservation(reservationInfo: reserveResponse, times: selectedSlots) { _ in
                                self.sendTeamReservationEmail(playerEmail: player.email, playerName: player.name, date: date, times: selectedSlots, device: space.device)
                                group.leave()
                            }
                        case .failure(let error):
                            hasError = true
                            Logger.shared.log("Error creando reserve para jugador: \(error.localizedDescription)")
                            group.leave()
                        }
                    }
                }

                group.notify(queue: .main) { [weak self] in
                    guard let self else { return }
                    if hasError || reserveIds.isEmpty {
                        completion(.failure(NSError(domain: "Training", code: 1, userInfo: [NSLocalizedDescriptionKey: "Error creando reserves"])))
                        return
                    }
                    self.reservationService.linkReservesToTraining(trainingId: trainingId, reserveIds: reserveIds) { result in
                        switch result {
                        case .success: completion(.success(()))
                        case .failure(let error): completion(.failure(error))
                        }
                    }
                }

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - Actualizar jugadores de equipo

    func updateTrainingPlayers(trainingId: String, playerIds: [String], completion: @escaping (Result<Void, Error>) -> Void) {
        reservationService.updateTrainingPlayers(trainingId: trainingId, playerIds: playerIds) { result in
            switch result {
            case .success: completion(.success(()))
            case .failure(let error): completion(.failure(error))
            }
        }
    }

    // MARK: - Crear training virtual

    func createVirtualTraining(
        date: Date,
        teamId: String,
        time: String,
        notes: String,
        players: [(id: String, email: String, name: String)],
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let dateFmt = DateFormatter()
        dateFmt.dateFormat = "yyyy-MM-dd"
        let playerIds = players.map { $0.id }

        let body: [String: Any] = [
            "status":     "active",
            "type":       "virtual",
            "start_date": dateFmt.string(from: date),
            "time":       time,
            "team":       teamId,
            "notes":      notes,
            "players":    playerIds.map { ["users_id": $0] }
        ]

        Task {
            do {
                let _: TrainingResponseModel = try await DirectusService.shared.sendRequest(
                    endpoint: "trainings",
                    method: .POST,
                    body: body
                )
                await MainActor.run {
                    for player in players {
                        self.sendVirtualTrainingEmail(playerEmail: player.email, playerName: player.name, date: date, time: time)
                    }
                    completion(.success(()))
                }
            } catch {
                await MainActor.run { completion(.failure(error)) }
            }
        }
    }

    // MARK: - Emails

    func sendIndividualReservationEmail(
        date: Date,
        device: String,
        times: [GamingSpaceTime],
        extraBlock: String = ""
    ) {
        guard let user = userManager.getUser(),
              let email = user.email, !email.isEmpty else { return }

        let fmt = DateFormatter()
        fmt.dateFormat = "dd/MM/yyyy"

        reservationService.sendReservationEmail(
            email: email,
            firstName: user.firstName ?? "",
            date: fmt.string(from: date),
            times: times.sorted { $0.value < $1.value }.map { $0.time }.joined(separator: " - "),
            device: device,
            extraBlock: extraBlock
        )
    }

    private func sendTeamReservationEmail(playerEmail: String, playerName: String, date: Date, times: [GamingSpaceTime], device: String) {
        guard !playerEmail.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        let fmt = DateFormatter()
        fmt.dateFormat = "dd/MM/yyyy"
        reservationService.sendReservationEmail(
            email: playerEmail, firstName: playerName,
            date: fmt.string(from: date),
            times: times.sorted { $0.value < $1.value }.map { $0.time }.joined(separator: " - "),
            device: device, extraBlock: ""
        )
    }

    private func sendVirtualTrainingEmail(playerEmail: String, playerName: String, date: Date, time: String) {
        guard !playerEmail.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        let fmt = DateFormatter()
        fmt.dateFormat = "dd/MM/yyyy"
        reservationService.sendReservationEmail(
            email: playerEmail, firstName: playerName,
            date: fmt.string(from: date),
            times: time, device: "Virtual", extraBlock: ""
        )
    }

    // MARK: - Helper: construir extraBlock para email

    func buildExtraBlock(
        date: Date,
        wantsSimulator: Bool,
        simulatorSlots: [GamingSpaceTime],
        simulatorDevice: String?,
        wantsExtraSpace: Bool,
        extraSpaceSlots: [GamingSpaceTime],
        extraSpaceDevice: String?
    ) -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = "dd/MM/yyyy"
        let dateStr = fmt.string(from: date)

        if wantsSimulator, !simulatorSlots.isEmpty, let device = simulatorDevice {
            let times = simulatorSlots.sorted { $0.value < $1.value }.map { $0.time }.joined(separator: " - ")
            return "<p><strong><u>Reserva extra incluida:</u></strong><br><strong>Fecha:</strong> \(dateStr)<br><strong>Hora:</strong> \(times)<br><strong>Dispositivo:</strong> \(device)</p>"
        }
        if wantsExtraSpace, !extraSpaceSlots.isEmpty, let device = extraSpaceDevice {
            let times = extraSpaceSlots.sorted { $0.value < $1.value }.map { $0.time }.joined(separator: " - ")
            return "<p><strong><u>Reserva extra incluida:</u></strong><br><strong>Fecha:</strong> \(dateStr)<br><strong>Hora:</strong> \(times)<br><strong>Dispositivo:</strong> \(device)</p>"
        }
        return ""
    }
}