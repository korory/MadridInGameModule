import SwiftUI

class ReservationFlowViewModel: ObservableObject {
    @Published var currentStep: Int = 0
    @Published var selectedDate: Date?
    @Published var availableSlots: [GamingSpaceTime] = []
    @Published var selectedSlots: [GamingSpaceTime] = []
    @Published var enabledSlots: [GamingSpaceTime] = []
    @Published var markedDates: [MarkTrainingDatesAndReservations] = []
    @Published var availableSpaces: [Space] = []
    @Published var selectedSpace: Space?
    @Published var isLoading: Bool = false
    @Published var isCreatingReservation: Bool = false
    @Published var reservationSuccess: Bool = false
    @Published var userManager = UserManager.shared
    @Published var personalReservations: Bool = false
    @Published var selectedPlayers: [String] = []
    @Published var teamPlayers: [TeamUser] = []
    @Published var selectedSpaceType: String? = nil
    @Published var reservationNotes: String = ""
    @Published var optionsSeleccted: String = ""
    @Published var selectedTime: String = ""
    @Published var individualSelectedInformation: IndividualReservation?
    @Published var teamSelectedInformation: EventModel?
    @Published var showLegendPopup = false

    var onReservationSuccess: () -> Void
    var onReservationFail: () -> Void

    // MARK: - Summary tokens

    var summaryTokens: [String] {
        var result: [String] = []
        let step = currentStep
        let isPersonal = personalReservations

        if !isPersonal, step > 0, let type = selectedSpaceType {
            result.append(type)
        }
        if !isPersonal, step > 1, !selectedPlayers.isEmpty {
            result.append(selectedPlayers.joined(separator: ", "))
        }
        let dateThreshold = isPersonal ? 0 : 2
        if step > dateThreshold, let date = selectedDate {
            result.append(date.toUIDateString())
        }
        let spaceThreshold = isPersonal ? 1 : 3
        if step > spaceThreshold, let space = selectedSpace {
            result.append(space.device)
        }
        return result
    }

    private let reservationService = ReservationService()
    let dateFormatter = DateFormatter()

    init(
        personalReservations: Bool,
        teamReservationInformation: EventModel?,
        individualReservationInformation: IndividualReservation?,
        onReservationSuccess: @escaping () -> Void,
        onReservationFail: @escaping () -> Void
    ) {
        self.onReservationSuccess = onReservationSuccess
        self.onReservationFail = onReservationFail
        self.personalReservations = personalReservations
        self.individualSelectedInformation = individualReservationInformation
        self.teamSelectedInformation = teamReservationInformation

        self.getBlockedDays()
        self.getTeamsUsers()
        self.fetchTeamReservationsByUser { self.isLoading = false }
        self.fetchTeamTrainingDates()
        self.populateFromExistingInformation()
    }

    // MARK: - Mapeo spaceType backend ↔ UI

    static func spaceTypeToUI(_ backendValue: String?) -> String? {
        switch backendValue?.lowercased() {
        case "centre":  return "E-Sports Center"
        case "virtual": return "Virtual"
        default:        return nil
        }
    }

    static func spaceTypeToBackend(_ uiValue: String?) -> String {
        switch uiValue?.lowercased() {
        case "e-sports center": return "centre"
        case "virtual":         return "virtual"
        default:                return "centre"
        }
    }

    // MARK: - Pre-relleno desde información existente

    private func populateFromExistingInformation() {
        if let team = teamSelectedInformation {
            populateFromTeamReservation(team)
        } else if let individual = individualSelectedInformation {
            populateFromIndividualReservation(individual)
        }
    }

    private func populateFromTeamReservation(_ event: EventModel) {
        reservationNotes  = event.notes ?? ""
        selectedSpaceType = ReservationFlowViewModel.spaceTypeToUI(event.type)
        selectedTime      = event.time
        selectedDate      = Utils.createDate(from: event.startDate)

        selectedPlayers = event.players?.compactMap { playerModel -> String? in
            guard let playerId = playerModel.userId?.id else { return nil }
            return teamPlayers.first(where: { $0.usersId?.id == playerId })?.usersId?.username
                ?? playerModel.userId?.name
        } ?? []

        guard event.type.lowercased() != "virtual",
              let reserveSlotId = event.reserves?.first?.slot else { return }

        fetchAvailableSpaces { [weak self] in
            guard let self else { return }
            self.selectedSpace = self.availableSpaces.first(where: {
                $0.slots.contains(where: { $0.id == reserveSlotId })
            })
            let dayValue = self.calculateDayValue(for: self.selectedDate)
            self.fetchAvailableSlots(for: dayValue) { [weak self] in
                guard let self else { return }
                let reserveTimes = Set(
                    event.reserves?.first?.times?.compactMap { $0.gamingSpaceTimesID?.time } ?? []
                )
                self.selectedSlots = self.availableSlots.filter { reserveTimes.contains($0.time) }
                self.updateEnabledSlots()
            }
        }
    }

    private func populateFromIndividualReservation(_ reservation: IndividualReservation) {
        selectedDate = Utils.createDate(from: reservation.date)

        fetchAvailableSpaces { [weak self] in
            guard let self else { return }

            self.selectedSpace = self.availableSpaces.first(where: {
                $0.slots.contains(where: { $0.id == reservation.slot.id })
            })

            let dayValue = self.calculateDayValue(for: self.selectedDate)
            self.fetchAvailableSlots(for: dayValue) { [weak self] in
                guard let self else { return }
                let reserveTimes = Set(
                    reservation.times.compactMap { $0.gamingSpaceTimesID?.time }
                )
                self.selectedSlots = self.availableSlots.filter { reserveTimes.contains($0.time) }
                self.updateEnabledSlots()
            }
        }
    }

    // MARK: - Navegación

    func goToNextStep() { if currentStep < 2 { currentStep += 1 } }
    func goToPreviousStep() { if currentStep > 0 { currentStep -= 1 } }

    // MARK: - Equipo

    var filteredSpaces: [Space] {
        guard let type = selectedSpaceType else { return availableSpaces }
        return availableSpaces.filter { $0.type == type }
    }

    func getTeamsUsers() {
        self.teamPlayers = userManager.getSelectedTeam()?.users ?? []
    }

    func fetchTeamReservationsByUser(completion: @escaping () -> Void) {
        guard let user = userManager.getUser(), let userId = user.id else { return }
        isLoading = true
        reservationService.getReservesByUser(userId: userId) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let reservations):
                    let marked = reservations
                        .compactMap { Utils.createDate(from: $0.date) }
                        .map { MarkTrainingDatesAndReservations(date: $0, individualReservation: true) }
                    self.markedDates.append(contentsOf: marked)
                case .failure(let error):
                    Logger.shared.log("Error al obtener reservas: \(error)")
                }
                self.isLoading = false
                completion()
            }
        }
    }

    func fetchTeamTrainingDates() {
        guard let userId = userManager.getUser()?.id,
              let teamId = userManager.getSelectedTeam()?.id else { return }

        reservationService.getAllTrainings(teamId: teamId, userId: userId) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let trainings):
                    let marked = trainings.compactMap { training -> MarkTrainingDatesAndReservations? in
                        guard let date = Utils.createDate(from: training.startDate) else { return nil }
                        return MarkTrainingDatesAndReservations(date: date, individualReservation: false)
                    }
                    self.markedDates.append(contentsOf: marked)
                case .failure(let error):
                    Logger.shared.log("Error al obtener entrenos de equipo: \(error)")
                }
            }
        }
    }

    func getBlockedDays() {
        isLoading = true
        reservationService.getAllBlockedDays { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let blockedDays):
                    let marked = blockedDays
                        .compactMap { $0.date.flatMap { Utils.createDate(from: $0) } }
                        .map { MarkTrainingDatesAndReservations(date: $0, blockedDays: true) }
                    self.markedDates.append(contentsOf: marked)
                case .failure(let error):
                    Logger.shared.log("Error al obtener los dias bloqueados: \(error)")
                }
                self.isLoading = false
            }
        }
    }

    // MARK: - Fecha

    func checkSelectedDate(_ stringDate: String) {
        let date = convertToDate(from: stringDate)
        if let matchingDate = markedDates.first(where: { $0.date == date }), matchingDate.blockedDays { return }
        self.selectedDate = date
    }

    func convertToDate(from dateString: String) -> Date? {
        let f = DateFormatter()
        f.dateFormat = "dd/MM/yyyy"
        return f.date(from: dateString)
    }

    // MARK: - Espacios

    func fetchAvailableSpaces(completion: (() -> Void)? = nil) {
        SpaceService.shared.fetchSpaces { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { completion?(); return }
                switch result {
                case .success(let spaces):
                    for space in spaces {
                        guard let t = space.translations.first(where: { $0.languagesCode == "es" }) else { continue }

                        if !self.personalReservations && t.device.lowercased().contains("simulador") {
                            continue
                        }

                        let mapped = Space(id: UUID().hashValue, device: t.device, description: t.description ?? "", slots: space.slots, type: "")
                        self.availableSpaces.append(mapped)
                    }
                case .failure(let error):
                    Logger.shared.log("Error fetching spaces: \(error.localizedDescription)")
                }
                completion?()
            }
        }
    }

    func selectSpace(_ space: Space) {
        if selectedSpace?.id == space.id {
            selectedSpace = nil
        } else {
            selectedSpace = space
            availableSlots = []
            selectedSlots = []
            enabledSlots = []
        }
    }

    // MARK: - Slots

    func fetchAvailableSlots(for dayValue: Int, completion: (() -> Void)? = nil) {
        WeekTimeService.shared.fetchWeekTimeByDay(dayValue: dayValue) { [weak self] result in
            DispatchQueue.main.async {
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
                    let isSimulador = self?.selectedSpace?.device.lowercased().contains("simulador") ?? false
                    self?.availableSlots = isSimulador ? sorted : sorted.filter { !$0.time.hasSuffix(":30") }
                    self?.updateEnabledSlots()
                case .failure(let error):
                    Logger.shared.log("Error fetching slots: \(error)")
                }
                completion?()
            }
        }
    }

    func updateEnabledSlots() {
        guard !selectedSlots.isEmpty else { enabledSlots = availableSlots; return }
        let isSimulador = selectedSpace?.device.lowercased().contains("simulador") ?? false
        let maxSlots = isSimulador ? 1 : (personalReservations ? 3 : 2)
        let sortedSelected = selectedSlots.sorted { $0.value < $1.value }
        let minValue = sortedSelected.first?.value ?? 0
        let maxValue = sortedSelected.last?.value ?? 0
        enabledSlots = availableSlots.filter { slot in
            (slot.value >= minValue && slot.value <= maxValue + 1 && slot.value <= minValue + (maxSlots - 1))
            || selectedSlots.contains(where: { $0.id == slot.id })
        }
    }

    func toggleSlotSelection(_ slot: GamingSpaceTime) {
        if selectedSlots.contains(where: { $0.id == slot.id }) {
            selectedSlots.removeAll { $0.id == slot.id }
        } else {
            selectedSlots.append(slot)
        }
        updateEnabledSlots()
    }

    func calculateDayValue(for date: Date?) -> Int {
        guard let date else { return 0 }
        let weekday = Calendar.current.component(.weekday, from: date)
        return weekday == 1 ? 7 : weekday - 1
    }

    // MARK: - Crear reserva individual

    func createReservation() {
        guard let date = selectedDate,
              let space = selectedSpace,
              let userId = userManager.getUser()?.id,
              !selectedSlots.isEmpty else {
            Logger.shared.log("Datos incompletos para crear la reserva")
            return
        }
        let teamId = personalReservations ? nil : userManager.getSelectedTeam()?.id
        let reservation = Reservation(
            id: 0, status: "active",
            slot: space.slots.first ?? Slot(id: 0, position: "", space: 0),
            date: date, user: userId, team: teamId,
            training: nil, qrImage: nil, qrValue: nil,
            times: selectedSlots, peripheralLoans: []
        )
        self.isCreatingReservation = true
        reservationService.createReservation(reservation: reservation) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let r): self?.updateReservationWithQR(reservationInfo: r)
                case .failure(let error):
                    self?.isCreatingReservation = false
                    self?.reservationSuccess = false
                    self?.onReservationFail()
                    Logger.shared.log("Error al crear la reserva: \(error.localizedDescription)")
                }
            }
        }
    }

    // MARK: - Actualizar reserva individual (edición)

    func updateIndividualReservation() {
        guard let reservationId = individualSelectedInformation?.id,
              let date = selectedDate,
              let space = selectedSpace,
              !selectedSlots.isEmpty else {
            Logger.shared.log("Datos incompletos para actualizar la reserva individual")
            return
        }

        isCreatingReservation = true

        let slotToUse = space.slots.first ?? Slot(id: 0, position: "", space: 0)
        let timesMapped = selectedSlots.map { ["gaming_space_times_id": ["id": $0.id]] }

        let dateFmt = DateFormatter()
        dateFmt.dateFormat = "yyyy-MM-dd"

        let body: [String: Any] = [
            "date": dateFmt.string(from: date),
            "slot": slotToUse.id,
            "times": timesMapped
        ]

        Task {
            do {
                let _: ReserveResponseModel = try await DirectusService.shared.sendRequest(
                    endpoint: "gaming_space_reserves/\(reservationId)",
                    method: .PATCH,
                    body: body
                )
                await MainActor.run {
                    self.isCreatingReservation = false
                    self.reservationSuccess = true
                    self.onReservationSuccess()
                    Logger.shared.log("Reserva individual actualizada correctamente")
                }
            } catch {
                await MainActor.run {
                    self.isCreatingReservation = false
                    self.reservationSuccess = false
                    self.onReservationFail()
                    Logger.shared.log("Error al actualizar reserva individual: \(error.localizedDescription)")
                }
            }
        }
    }

    func updateReservationWithQR(reservationInfo: ReserveResponse) {
        guard let reservationId = reservationInfo.id,
              let qrValue = reservationInfo.qrValue,
              let date = selectedDate,
              let space = selectedSpace,
              let userId = userManager.getUser()?.id,
              !selectedSlots.isEmpty,
              let qrImage = QRCodeGenerator.generateQRCode(with: qrValue) else {
            Logger.shared.log("Datos incompletos para actualizar la reserva con QR")
            return
        }
        UploadImageService().uploadImage(image: qrImage, fileName: "\(qrValue).jpg") { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                guard let data = response.data(using: .utf8),
                      let decoded = try? JSONDecoder().decode(SendImageResponse.self, from: data) else {
                    Logger.shared.log("Error al decodificar respuesta de imagen")
                    return
                }
                let fileId = decoded.data.id
                let reservation = Reservation(
                    id: 0, status: "active",
                    slot: space.slots.first ?? Slot(id: 0, position: "", space: 0),
                    date: date, user: userId, team: nil,
                    training: nil, qrImage: fileId, qrValue: qrValue,
                    times: self.selectedSlots, peripheralLoans: []
                )
                self.reservationService.updateExistingReservation(reservationId: reservationId, qrImage: fileId, reservation: reservation) { result in
                    DispatchQueue.main.async {
                        self.isLoading = false
                        switch result {
                        case .success:
                            self.isCreatingReservation = true
                            self.reservationSuccess = true
                            self.onReservationSuccess()
                        case .failure(let error):
                            self.isCreatingReservation = true
                            self.reservationSuccess = false
                            self.onReservationFail()
                            Logger.shared.log("Error al actualizar la reserva: \(error.localizedDescription)")
                        }
                    }
                }
            case .failure(let error):
                Logger.shared.log("Error al subir la imagen: \(error.localizedDescription)")
                self.isCreatingReservation = true
                self.reservationSuccess = false
                self.onReservationFail()
            }
        }
    }

    // MARK: - Crear reserva de equipo (Training centre)

    func createTeamReservation() {
        guard let date = selectedDate,
              let space = selectedSpace,
              let teamId = userManager.getSelectedTeam()?.id,
              !selectedSlots.isEmpty else {
            Logger.shared.log("Datos incompletos para crear la reserva de equipo")
            return
        }

        let playerIds = selectedPlayers.compactMap { username in
            teamPlayers.first { $0.usersId?.username == username }?.usersId?.id
        }

        let dateFmt = DateFormatter()
        dateFmt.dateFormat = "yyyy-MM-dd"
        let dateString = dateFmt.string(from: date)
        let timeString = selectedSlots.sorted { $0.value < $1.value }.first?.time ?? selectedTime
        let typeValue = ReservationFlowViewModel.spaceTypeToBackend(selectedSpaceType)
        let slotToUse = space.slots.first ?? Slot(id: 0, position: "", space: 0)

        isCreatingReservation = true

        let trainingRequest = TrainingRequest(
            status: "active", type: typeValue,
            startDate: dateString, time: timeString,
            teamId: teamId, notes: reservationNotes,
            playerIds: playerIds, reserveIds: []
        )

        reservationService.createTraining(request: trainingRequest) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let trainingResponse):
                    guard let trainingId = trainingResponse.id else {
                        self.isCreatingReservation = false
                        self.onReservationFail()
                        return
                    }

                    let group = DispatchGroup()
                    var reserveIds: [Int] = []
                    var hasError = false

                    for playerId in playerIds {
                        group.enter()

                        let reservation = Reservation(
                            id: 0, status: "active",
                            slot: slotToUse,
                            date: date, user: playerId, team: teamId,
                            training: trainingId,
                            qrImage: nil, qrValue: nil,
                            times: self.selectedSlots, peripheralLoans: []
                        )

                        self.reservationService.createReservation(reservation: reservation) { [weak self] result in
                            guard let self else { group.leave(); return }
                            DispatchQueue.main.async {
                                switch result {
                                case .success(let reserveResponse):
                                    guard let reserveId = reserveResponse.id else {
                                        hasError = true
                                        group.leave()
                                        return
                                    }
                                    reserveIds.append(reserveId)
                                    self.generateAndUploadQR(for: reserveResponse) {
                                        group.leave()
                                    }
                                case .failure(let error):
                                    hasError = true
                                    Logger.shared.log("Error al crear reserve para jugador: \(error.localizedDescription)")
                                    group.leave()
                                }
                            }
                        }
                    }

                    group.notify(queue: .main) { [weak self] in
                        guard let self else { return }

                        if hasError || reserveIds.isEmpty {
                            self.isCreatingReservation = false
                            self.onReservationFail()
                            return
                        }

                        self.reservationService.linkReservesToTraining(
                            trainingId: trainingId,
                            reserveIds: reserveIds
                        ) { [weak self] result in
                            guard let self else { return }
                            DispatchQueue.main.async {
                                self.isCreatingReservation = false
                                switch result {
                                case .success:
                                    self.reservationSuccess = true
                                    self.onReservationSuccess()
                                    Logger.shared.log("Training centre creado con \(reserveIds.count) reserves")
                                case .failure(let error):
                                    self.reservationSuccess = false
                                    self.onReservationFail()
                                    Logger.shared.log("Error al vincular reserves: \(error.localizedDescription)")
                                }
                            }
                        }
                    }

                case .failure(let error):
                    self.isCreatingReservation = false
                    self.onReservationFail()
                    Logger.shared.log("Error al crear el training: \(error.localizedDescription)")
                }
            }
        }
    }

    // MARK: - Helper: Generar y subir QR

    private func generateAndUploadQR(for reserveResponse: ReserveResponse, completion: @escaping () -> Void) {
        guard let reserveId = reserveResponse.id,
              let qrValue = reserveResponse.qrValue,
              let qrImage = QRCodeGenerator.generateQRCode(with: qrValue) else {
            completion()
            return
        }

        UploadImageService().uploadImage(image: qrImage, fileName: "\(qrValue).jpg") { [weak self] result in
            guard let self else { completion(); return }
            switch result {
            case .success(let response):
                guard let data = response.data(using: .utf8),
                      let decoded = try? JSONDecoder().decode(SendImageResponse.self, from: data) else {
                    completion()
                    return
                }
                let fileId = decoded.data.id

                self.reservationService.updateExistingReservation(
                    reservationId: reserveId,
                    qrImage: fileId,
                    reservation: Reservation(
                        id: reserveId, status: "active",
                        slot: Slot(id: 0, position: "", space: 0),
                        date: Date(), user: nil, team: nil,
                        training: nil, qrImage: fileId, qrValue: qrValue,
                        times: self.selectedSlots, peripheralLoans: []
                    )
                ) { _ in
                    completion()
                }

            case .failure(let error):
                Logger.shared.log("Error al subir QR: \(error.localizedDescription)")
                completion()
            }
        }
    }

    // MARK: - Editar reserva de equipo (Training existente)

    func updateCenterTeamReservation() {
        guard let date = selectedDate,
              let space = selectedSpace,
              let trainingId = teamSelectedInformation?.id,
              let reserveId = teamSelectedInformation?.reserves?.first?.id,
              !selectedSlots.isEmpty else {
            Logger.shared.log("Datos incompletos para actualizar la reserva de equipo")
            return
        }
        let dateFmt = DateFormatter()
        dateFmt.dateFormat = "yyyy-MM-dd"
        let dateString = dateFmt.string(from: date)
        let timeString = selectedSlots.sorted { $0.value < $1.value }.first?.time ?? selectedTime
        let typeValue = ReservationFlowViewModel.spaceTypeToBackend(selectedSpaceType)
        let playerIds = selectedPlayers.compactMap { username in
            teamPlayers.first { $0.usersId?.username == username }?.usersId?.id
        }

        isCreatingReservation = true
        reservationService.updateExistingReserveForTeam(
            reserveId: reserveId,
            date: date,
            slot: space.slots.first ?? Slot(id: 0, position: "", space: 0),
            times: selectedSlots
        ) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.reservationService.updateTraining(
                        trainingId: trainingId, type: typeValue,
                        startDate: dateString, time: timeString,
                        notes: self.reservationNotes, playerIds: playerIds
                    ) { [weak self] result in
                        guard let self else { return }
                        DispatchQueue.main.async {
                            self.isCreatingReservation = false
                            switch result {
                            case .success:
                                self.reservationSuccess = true
                                self.onReservationSuccess()
                            case .failure(let error):
                                self.reservationSuccess = false
                                self.onReservationFail()
                                Logger.shared.log("Error al actualizar el training: \(error.localizedDescription)")
                            }
                        }
                    }
                case .failure(let error):
                    self.isCreatingReservation = false
                    self.onReservationFail()
                    Logger.shared.log("Error al actualizar la reserve: \(error.localizedDescription)")
                }
            }
        }
    }

    // MARK: - Crear training virtual

    func createVirtualTeamReservation() {
        guard let date = selectedDate,
              let teamId = userManager.getSelectedTeam()?.id,
              !selectedTime.isEmpty else {
            Logger.shared.log("Datos incompletos para crear reserva virtual")
            return
        }

        let dateFmt = DateFormatter()
        dateFmt.dateFormat = "yyyy-MM-dd"

        let playerIds = selectedPlayers.compactMap { username -> String? in
            teamPlayers.first { $0.usersId?.username == username }?.usersId?.id
        }

        isCreatingReservation = true

        let body: [String: Any] = [
            "status":     "active",
            "type":       "virtual",
            "start_date": dateFmt.string(from: date),
            "time":       selectedTime,
            "team":       teamId,
            "notes":      reservationNotes,
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
                    self.isCreatingReservation = false
                    self.reservationSuccess = true
                    self.onReservationSuccess()
                    Logger.shared.log("Training virtual creado correctamente")
                }
            } catch {
                await MainActor.run {
                    self.isCreatingReservation = false
                    self.reservationSuccess = false
                    self.onReservationFail()
                    Logger.shared.log("Error al crear training virtual: \(error.localizedDescription)")
                }
            }
        }
    }

    // MARK: - Editar training virtual

    func updateVirtualTeamReservation() {
        guard let date = selectedDate,
              let trainingId = teamSelectedInformation?.id,
              !selectedTime.isEmpty else { return }

        let dateFmt = DateFormatter()
        dateFmt.dateFormat = "yyyy-MM-dd"

        let playerIds = selectedPlayers.compactMap { username -> String? in
            teamPlayers.first { $0.usersId?.username == username }?.usersId?.id
        }

        isCreatingReservation = true

        reservationService.updateTraining(
            trainingId: trainingId,
            type: "virtual",
            startDate: dateFmt.string(from: date),
            time: selectedTime,
            notes: reservationNotes,
            playerIds: playerIds
        ) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                self.isCreatingReservation = false
                switch result {
                case .success:
                    self.reservationSuccess = true
                    self.onReservationSuccess()
                case .failure(let error):
                    self.reservationSuccess = false
                    self.onReservationFail()
                    Logger.shared.log("Error al actualizar training virtual: \(error.localizedDescription)")
                }
            }
        }
    }
}
