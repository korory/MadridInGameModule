import SwiftUI

class ReservationFlowViewModel: ObservableObject {
    // MARK: - UI State
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

    // MARK: - Slot occupancy
    @Published var occupiedTimeIds: Set<Int> = []
    @Published var isLoadingOccupancy: Bool = false
    @Published var occupiedSimulatorTimeIds: Set<Int> = []
    @Published var isLoadingSimulatorOccupancy: Bool = false
    @Published var occupiedExtraSpaceTimeIds: Set<Int> = []
    @Published var isLoadingExtraSpaceOccupancy: Bool = false

    // Per-slot occupancy maps: [slotId: Set<timeId>] — used to pick a free slot at booking time
    private var slotOccupancyMap: [Int: Set<Int>] = [:]
    private var simulatorSlotOccupancyMap: [Int: Set<Int>] = [:]
    private var extraSpaceSlotOccupancyMap: [Int: Set<Int>] = [:]

    // MARK: - Simulator add-on
    @Published var wantsSimulator: Bool = false
    @Published var simulatorSelectedSlots: [GamingSpaceTime] = []
    @Published var availableSimulatorSlots: [GamingSpaceTime] = []
    @Published var simulatorSpace: Space?

    // MARK: - Extra space add-on
    @Published var wantsExtraSpace: Bool = false
    @Published var extraSpace: Space?
    @Published var extraSpaceSelectedSlots: [GamingSpaceTime] = []
    @Published var availableExtraSpaceSlots: [GamingSpaceTime] = []
    @Published var enabledExtraSpaceSlots: [GamingSpaceTime] = []

    // MARK: - Dependencies
    private let apiManager = ReservationAPIManager()
    private let userManager = UserManager.shared
    var onReservationSuccess: () -> Void
    var onReservationFail: () -> Void

    // MARK: - Computed

    var isSelectedSpaceSimulator: Bool {
        selectedSpace?.device.lowercased().contains("simulador") ?? false
    }

    var personalStepCount: Int {
        if isSelectedSpaceSimulator {
            return wantsExtraSpace ? 6 : 4
        } else {
            return wantsSimulator ? 5 : 4
        }
    }

    var summaryTokens: [String] {
        var result: [String] = []
        let step = currentStep
        let isPersonal = personalReservations
        if !isPersonal, step > 0, let type = selectedSpaceType { result.append(type) }
        if !isPersonal, step > 1, !selectedPlayers.isEmpty { result.append(selectedPlayers.joined(separator: ", ")) }
        if step > (isPersonal ? 0 : 2), let date = selectedDate { result.append(date.toUIDateString()) }
        if step > (isPersonal ? 1 : 3), let space = selectedSpace { result.append(space.device) }
        return result
    }

    var filteredSpaces: [Space] {
        guard let type = selectedSpaceType else { return availableSpaces }
        return availableSpaces.filter { $0.type == type }
    }

    var nonSimulatorSpaces: [Space] {
        availableSpaces.filter { !$0.device.lowercased().contains("simulador") }
    }

    // MARK: - Init

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

    // MARK: - Carga inicial de datos

    func getBlockedDays() {
        isLoading = true
        apiManager.fetchBlockedDays { [weak self] result in
            DispatchQueue.main.async {
                if case .success(let marked) = result { self?.markedDates.append(contentsOf: marked) }
                self?.isLoading = false
            }
        }
    }

    func getTeamsUsers() {
        self.teamPlayers = userManager.getSelectedTeam()?.users ?? []
    }

    func fetchTeamReservationsByUser(completion: @escaping () -> Void) {
        guard let userId = userManager.getUser()?.id else { return }
        isLoading = true
        apiManager.fetchUserReservations(userId: userId) { [weak self] result in
            DispatchQueue.main.async {
                if case .success(let marked) = result { self?.markedDates.append(contentsOf: marked) }
                self?.isLoading = false
                completion()
            }
        }
    }

    func fetchTeamTrainingDates() {
        guard let userId = userManager.getUser()?.id,
              let teamId = userManager.getSelectedTeam()?.id else { return }
        apiManager.fetchTeamTrainings(teamId: teamId, userId: userId) { [weak self] result in
            DispatchQueue.main.async {
                if case .success(let marked) = result { self?.markedDates.append(contentsOf: marked) }
            }
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
        selectedSpaceType = Self.spaceTypeToUI(event.type)
        selectedTime      = event.time
        selectedDate      = Utils.createDate(from: event.startDate)

        selectedPlayers = event.players?.compactMap { playerModel -> String? in
            guard let playerId = playerModel.userId?.id else { return nil }
            return teamPlayers.first(where: { $0.usersId?.id == playerId })?.usersId?.username ?? playerModel.userId?.name
        } ?? []

        guard event.type.lowercased() != "virtual",
              let reserveSlotId = event.reserves?.first?.slot else { return }

        fetchAvailableSpaces { [weak self] in
            guard let self else { return }
            self.selectedSpace = self.availableSpaces.first(where: { $0.slots.contains(where: { $0.id == reserveSlotId }) })
            self.fetchAvailableSlots(for: self.calculateDayValue(for: self.selectedDate)) { [weak self] in
                guard let self else { return }
                let reserveTimes = Set(event.reserves?.first?.times?.compactMap { $0.gamingSpaceTimesID?.time } ?? [])
                self.selectedSlots = self.availableSlots.filter { reserveTimes.contains($0.time) }
                self.updateEnabledSlots()
            }
        }
    }

    private func populateFromIndividualReservation(_ reservation: IndividualReservation) {
        selectedDate = Utils.createDate(from: reservation.date)
        fetchAvailableSpaces { [weak self] in
            guard let self else { return }
            self.selectedSpace = self.availableSpaces.first(where: { $0.slots.contains(where: { $0.id == reservation.slot.id }) })
            self.fetchAvailableSlots(for: self.calculateDayValue(for: self.selectedDate)) { [weak self] in
                guard let self else { return }
                let reserveTimes = Set(reservation.times.compactMap { $0.gamingSpaceTimesID?.time })
                self.selectedSlots = self.availableSlots.filter { reserveTimes.contains($0.time) }
                self.updateEnabledSlots()
            }
        }
    }

    // MARK: - Fecha

    func checkSelectedDate(_ stringDate: String) {
        let f = DateFormatter(); f.dateFormat = "dd/MM/yyyy"
        let date = f.date(from: stringDate)
        if let matching = markedDates.first(where: { $0.date == date }), matching.blockedDays { return }
        self.selectedDate = date
    }

    func calculateDayValue(for date: Date?) -> Int {
        guard let date else { return 0 }
        let weekday = Calendar.current.component(.weekday, from: date)
        return weekday == 1 ? 7 : weekday - 1
    }

    // MARK: - Espacios

    func fetchAvailableSpaces(completion: (() -> Void)? = nil) {
        apiManager.fetchSpaces(isPersonal: personalReservations) { [weak self] result in
            DispatchQueue.main.async {
                if case .success(let spaces) = result { self?.availableSpaces = spaces }
                completion?()
            }
        }
    }

    func selectSpace(_ space: Space) {
        if selectedSpace?.id == space.id {
            selectedSpace = nil
        } else {
            selectedSpace = space
            availableSlots = []; selectedSlots = []; enabledSlots = []
            occupiedTimeIds = []; isLoadingOccupancy = false
        }
    }

    // MARK: - Slots

    func fetchAvailableSlots(for dayValue: Int, completion: (() -> Void)? = nil) {
        let isSim = selectedSpace?.device.lowercased().contains("simulador") ?? false
        apiManager.fetchSlots(dayValue: dayValue, isSimulator: isSim) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { completion?(); return }
                if case .success(let slots) = result {
                    self.availableSlots = slots
                    self.isLoadingOccupancy = true
                    self.fetchOccupiedTimes(completion: completion)
                } else {
                    completion?()
                }
            }
        }
    }

    private func fetchOccupiedTimes(completion: (() -> Void)? = nil) {
        guard let space = selectedSpace, let date = selectedDate else {
            isLoadingOccupancy = false
            updateEnabledSlots()
            completion?()
            return
        }
        apiManager.fetchOccupiedTimeIds(space: space, date: date) { [weak self] occupied, perSlot in
            DispatchQueue.main.async {
                guard let self else { return }
                self.occupiedTimeIds = occupied
                self.slotOccupancyMap = perSlot
                self.isLoadingOccupancy = false
                self.updateEnabledSlots()
                completion?()
            }
        }
    }

    func updateEnabledSlots() {
        let notOccupied = availableSlots.filter { !occupiedTimeIds.contains($0.id) }
        guard !selectedSlots.isEmpty else { enabledSlots = notOccupied; return }
        let isSim = selectedSpace?.device.lowercased().contains("simulador") ?? false
        let maxSlots = isSim ? 1 : (personalReservations ? 3 : 2)
        let sorted = selectedSlots.sorted { $0.value < $1.value }
        let minVal = sorted.first?.value ?? 0
        let maxVal = sorted.last?.value ?? 0
        enabledSlots = notOccupied.filter { slot in
            (slot.value >= minVal && slot.value <= maxVal + 1 && slot.value <= minVal + (maxSlots - 1))
            || selectedSlots.contains(where: { $0.id == slot.id })
        }
    }

    func toggleSlotSelection(_ slot: GamingSpaceTime) {
        if selectedSlots.contains(where: { $0.id == slot.id }) {
            selectedSlots.removeAll { $0.id == slot.id }
        } else { selectedSlots.append(slot) }
        updateEnabledSlots()
    }

    // MARK: - Simulator add-on

    func findSimulatorSpace() {
        simulatorSpace = availableSpaces.first(where: { $0.device.lowercased().contains("simulador") })
    }

    func fetchSimulatorSlots(completion: (() -> Void)? = nil) {
        apiManager.fetchSlots(dayValue: calculateDayValue(for: selectedDate), isSimulator: true) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { completion?(); return }
                if case .success(let slots) = result {
                    self.availableSimulatorSlots = slots
                    self.isLoadingSimulatorOccupancy = true
                    self.fetchOccupiedSimulatorTimes(completion: completion)
                } else {
                    completion?()
                }
            }
        }
    }

    private func fetchOccupiedSimulatorTimes(completion: (() -> Void)? = nil) {
        guard let space = simulatorSpace, let date = selectedDate else {
            isLoadingSimulatorOccupancy = false
            completion?()
            return
        }
        apiManager.fetchOccupiedTimeIds(space: space, date: date) { [weak self] occupied, perSlot in
            DispatchQueue.main.async {
                guard let self else { return }
                self.occupiedSimulatorTimeIds = occupied
                self.simulatorSlotOccupancyMap = perSlot
                self.isLoadingSimulatorOccupancy = false
                completion?()
            }
        }
    }

    func toggleSimulatorSlotSelection(_ slot: GamingSpaceTime) {
        if simulatorSelectedSlots.contains(where: { $0.id == slot.id }) {
            simulatorSelectedSlots.removeAll { $0.id == slot.id }
        } else { simulatorSelectedSlots = [slot] }
    }

    func resetSimulatorSelection() {
        wantsSimulator = false; simulatorSelectedSlots = []; availableSimulatorSlots = []
        occupiedSimulatorTimeIds = []; isLoadingSimulatorOccupancy = false
    }

    // MARK: - Extra space add-on

    func selectExtraSpace(_ space: Space) {
        if extraSpace?.id == space.id {
            extraSpace = nil; availableExtraSpaceSlots = []; extraSpaceSelectedSlots = []; enabledExtraSpaceSlots = []
        } else {
            extraSpace = space; availableExtraSpaceSlots = []; extraSpaceSelectedSlots = []; enabledExtraSpaceSlots = []
        }
    }

    func fetchExtraSpaceSlots(completion: (() -> Void)? = nil) {
        apiManager.fetchSlots(dayValue: calculateDayValue(for: selectedDate), isSimulator: false) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { completion?(); return }
                if case .success(let slots) = result {
                    self.availableExtraSpaceSlots = slots
                    self.isLoadingExtraSpaceOccupancy = true
                    self.fetchOccupiedExtraSpaceTimes(completion: completion)
                } else {
                    completion?()
                }
            }
        }
    }

    private func fetchOccupiedExtraSpaceTimes(completion: (() -> Void)? = nil) {
        guard let space = extraSpace, let date = selectedDate else {
            isLoadingExtraSpaceOccupancy = false
            updateEnabledExtraSpaceSlots()
            completion?()
            return
        }
        apiManager.fetchOccupiedTimeIds(space: space, date: date) { [weak self] occupied, perSlot in
            DispatchQueue.main.async {
                guard let self else { return }
                self.occupiedExtraSpaceTimeIds = occupied
                self.extraSpaceSlotOccupancyMap = perSlot
                self.isLoadingExtraSpaceOccupancy = false
                self.updateEnabledExtraSpaceSlots()
                completion?()
            }
        }
    }

    func toggleExtraSpaceSlotSelection(_ slot: GamingSpaceTime) {
        if extraSpaceSelectedSlots.contains(where: { $0.id == slot.id }) {
            extraSpaceSelectedSlots.removeAll { $0.id == slot.id }
        } else { extraSpaceSelectedSlots.append(slot) }
        updateEnabledExtraSpaceSlots()
    }

    func updateEnabledExtraSpaceSlots() {
        let notOccupied = availableExtraSpaceSlots.filter { !occupiedExtraSpaceTimeIds.contains($0.id) }
        guard !extraSpaceSelectedSlots.isEmpty else { enabledExtraSpaceSlots = notOccupied; return }
        let sorted = extraSpaceSelectedSlots.sorted { $0.value < $1.value }
        let minVal = sorted.first?.value ?? 0
        let maxVal = sorted.last?.value ?? 0
        enabledExtraSpaceSlots = notOccupied.filter { slot in
            (slot.value >= minVal && slot.value <= maxVal + 1 && slot.value <= minVal + 2)
            || extraSpaceSelectedSlots.contains(where: { $0.id == slot.id })
        }
    }

    func resetExtraSpaceSelection() {
        wantsExtraSpace = false; extraSpace = nil; extraSpaceSelectedSlots = []; availableExtraSpaceSlots = []; enabledExtraSpaceSlots = []
        occupiedExtraSpaceTimeIds = []; isLoadingExtraSpaceOccupancy = false
    }

    // MARK: - Cross-blocking entre reserva principal y add-on

    private func hourFromTime(_ time: String) -> Int? {
        guard let h = time.split(separator: ":").first else { return nil }
        return Int(h)
    }

    func isSimulatorSlotBlockedByMain(_ slot: GamingSpaceTime) -> Bool {
        let blocked = Set(selectedSlots.compactMap { hourFromTime($0.time) })
        guard let h = hourFromTime(slot.time) else { return false }
        return blocked.contains(h)
    }

    func isExtraSpaceSlotBlockedBySimulator(_ slot: GamingSpaceTime) -> Bool {
        let blocked = Set(selectedSlots.compactMap { hourFromTime($0.time) })
        guard let h = hourFromTime(slot.time) else { return false }
        return blocked.contains(h)
    }

    // MARK: - Acciones de reserva

    /// Returns the first slot in the space that has NO conflict with the given times.
    /// Falls back to slots.first if all slots are somehow taken (server will reject, not our problem).
    private func findFreeSlot(in space: Space, occupancyMap: [Int: Set<Int>], for times: [GamingSpaceTime]) -> Slot {
        let selectedTimeIds = Set(times.map { $0.id })
        for slot in space.slots {
            let bookedTimeIds = occupancyMap[slot.id] ?? []
            if bookedTimeIds.isDisjoint(with: selectedTimeIds) {
                return slot
            }
        }
        return space.slots.first ?? Slot(id: 0, position: "", space: 0)
    }

    func createReservation() {
        guard let date = selectedDate,
              let space = selectedSpace,
              let userId = userManager.getUser()?.id,
              !selectedSlots.isEmpty else { return }

        isCreatingReservation = true
        let teamId = personalReservations ? nil : userManager.getSelectedTeam()?.id
        let slot = findFreeSlot(in: space, occupancyMap: slotOccupancyMap, for: selectedSlots)

        apiManager.createIndividualReservation(date: date, slot: slot, userId: userId, teamId: teamId, times: selectedSlots) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                switch result {
                case .success(let reserveResponse):
                    self.apiManager.uploadQRAndUpdateReservation(reservationInfo: reserveResponse, times: self.selectedSlots) { [weak self] qrResult in
                        DispatchQueue.main.async {
                            guard let self else { return }
                            switch qrResult {
                            case .success:
                                self.createAddonIfNeeded { [weak self] addonSuccess in
                                    DispatchQueue.main.async {
                                        guard let self else { return }
                                        self.sendEmailWithAddon()
                                        self.isCreatingReservation = false
                                        if addonSuccess {
                                            self.reservationSuccess = true; self.onReservationSuccess()
                                        } else {
                                            self.reservationSuccess = false; self.onReservationFail()
                                        }
                                    }
                                }
                            case .failure:
                                self.isCreatingReservation = false; self.reservationSuccess = false; self.onReservationFail()
                            }
                        }
                    }
                case .failure:
                    self.isCreatingReservation = false; self.reservationSuccess = false; self.onReservationFail()
                }
            }
        }
    }

    func updateIndividualReservation() {
        guard let reservationId = individualSelectedInformation?.id,
              let date = selectedDate, let space = selectedSpace, !selectedSlots.isEmpty else { return }

        isCreatingReservation = true
        let slot = space.slots.first ?? Slot(id: 0, position: "", space: 0)

        apiManager.updateIndividualReservation(reservationId: reservationId, date: date, slot: slot, times: selectedSlots) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                self.isCreatingReservation = false
                switch result {
                case .success: self.reservationSuccess = true; self.onReservationSuccess()
                case .failure: self.reservationSuccess = false; self.onReservationFail()
                }
            }
        }
    }

    func createTeamReservation() {
        guard let date = selectedDate, let space = selectedSpace,
              let teamId = userManager.getSelectedTeam()?.id, !selectedSlots.isEmpty else { return }

        let players = resolvePlayerTuples()
        let time = selectedSlots.sorted { $0.value < $1.value }.first?.time ?? selectedTime
        let spaceType = Self.spaceTypeToBackend(selectedSpaceType)

        isCreatingReservation = true
        apiManager.createTeamTraining(date: date, space: space, teamId: teamId, notes: reservationNotes, spaceType: spaceType, time: time, players: players, selectedSlots: selectedSlots) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                self.isCreatingReservation = false
                switch result {
                case .success: self.reservationSuccess = true; self.onReservationSuccess()
                case .failure: self.reservationSuccess = false; self.onReservationFail()
                }
            }
        }
    }

    func updateCenterTeamReservation() {
        guard let trainingId = teamSelectedInformation?.id else { return }
        let playerIds = selectedPlayers.compactMap { username in
            teamPlayers.first { $0.usersId?.username == username }?.usersId?.id
        }
        isCreatingReservation = true
        apiManager.updateTrainingPlayers(trainingId: trainingId, playerIds: playerIds) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                self.isCreatingReservation = false
                switch result {
                case .success: self.reservationSuccess = true; self.onReservationSuccess()
                case .failure: self.reservationSuccess = false; self.onReservationFail()
                }
            }
        }
    }

    func createVirtualTeamReservation() {
        guard let date = selectedDate,
              let teamId = userManager.getSelectedTeam()?.id, !selectedTime.isEmpty else { return }

        let players = resolvePlayerTuples()
        isCreatingReservation = true

        apiManager.createVirtualTraining(date: date, teamId: teamId, time: selectedTime, notes: reservationNotes, players: players) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                self.isCreatingReservation = false
                switch result {
                case .success: self.reservationSuccess = true; self.onReservationSuccess()
                case .failure: self.reservationSuccess = false; self.onReservationFail()
                }
            }
        }
    }

    func updateVirtualTeamReservation() {
        guard let trainingId = teamSelectedInformation?.id else { return }
        let playerIds = selectedPlayers.compactMap { username -> String? in
            teamPlayers.first { $0.usersId?.username == username }?.usersId?.id
        }
        isCreatingReservation = true
        apiManager.updateTrainingPlayers(trainingId: trainingId, playerIds: playerIds) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                self.isCreatingReservation = false
                switch result {
                case .success: self.reservationSuccess = true; self.onReservationSuccess()
                case .failure: self.reservationSuccess = false; self.onReservationFail()
                }
            }
        }
    }

    // MARK: - Helpers privados

    private func createAddonIfNeeded(completion: @escaping (Bool) -> Void) {
        guard let date = selectedDate, let userId = userManager.getUser()?.id else { completion(true); return }

        if wantsSimulator, !simulatorSelectedSlots.isEmpty, let simSpace = simulatorSpace {
            let slot = findFreeSlot(in: simSpace, occupancyMap: simulatorSlotOccupancyMap, for: simulatorSelectedSlots)
            apiManager.createAddonReservation(date: date, userId: userId, addonSlot: slot, addonTimes: simulatorSelectedSlots) { result in
                completion(result.isSuccess)
            }
            return
        }

        if wantsExtraSpace, !extraSpaceSelectedSlots.isEmpty, let extra = extraSpace {
            let slot = findFreeSlot(in: extra, occupancyMap: extraSpaceSlotOccupancyMap, for: extraSpaceSelectedSlots)
            apiManager.createAddonReservation(date: date, userId: userId, addonSlot: slot, addonTimes: extraSpaceSelectedSlots) { result in
                completion(result.isSuccess)
            }
            return
        }

        completion(true)
    }

    private func sendEmailWithAddon() {
        guard let date = selectedDate, let device = selectedSpace?.device else { return }
        let extraBlock = apiManager.buildExtraBlock(
            date: date,
            wantsSimulator: wantsSimulator, simulatorSlots: simulatorSelectedSlots, simulatorDevice: simulatorSpace?.device,
            wantsExtraSpace: wantsExtraSpace, extraSpaceSlots: extraSpaceSelectedSlots, extraSpaceDevice: extraSpace?.device
        )
        apiManager.sendIndividualReservationEmail(date: date, device: device, times: selectedSlots, extraBlock: extraBlock)
    }

    private func resolvePlayerTuples() -> [(id: String, email: String, name: String)] {
        selectedPlayers.compactMap { username -> (id: String, email: String, name: String)? in
            guard let user = teamPlayers.first(where: { $0.usersId?.username == username }),
                  let id = user.usersId?.id else { return nil }
            return (id: id, email: user.usersId?.email ?? "", name: username)
        }
    }
}

// MARK: - Result extension helper

extension Result {
    var isSuccess: Bool {
        if case .success = self { return true }
        return false
    }
}
