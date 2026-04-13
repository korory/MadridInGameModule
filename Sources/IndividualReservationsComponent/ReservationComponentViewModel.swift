import SwiftUI

class ReservationComponentViewModel: ObservableObject {
    
    private var trainingsTeamLimit: Int = 3

    @Published var isReservationFlowPresented = false

    @Published var userManager = UserManager.shared

    @Published var personalReservations: Bool = false

    @Published var isRemoveTranning: Bool = false
    @Published var isSelectTranning: Bool = false

    @Published var allIndividualReservations: [IndividualReservation] = []
    @Published var allTeamReservations: [EventModel] = []
    @Published var individualSelectedInformation: IndividualReservation?
    @Published var teamSelectedInformation: EventModel?

    @Published var cancelReservation: Bool = false
    @Published var selectedReservation: Reservation?

    @Published var dniIsMissing: Bool = false
    @Published var dniError: String? = nil

    @Published var noReservationAllowed: Bool = false
    @Published var noReservationAllowedWithoutDNI: Bool = false

    @Published var isLoading: Bool = true
    @Published var showToastSuccess: Bool = false
    @Published var showToastFailure: Bool = false
    @Published var showToastDeleteSuccess: Bool = false
    @Published var showToastDeleteFailure: Bool = false

    private let reservationService = ReservationService()

    init(personalReservations: Bool = false) {
        self.personalReservations = personalReservations
    }

    func getUserRol() -> String {
        let userId = userManager.getUser()?.id
        let teamPlayers = userManager.getSelectedTeam()?.users ?? []

        if (!teamPlayers.isEmpty) {
            for player in teamPlayers {
                if (userId == player.usersId?.id) {
                    return player.roles?.name ?? "No Role"
                }
            }
        }

        return ""
    }

    func getAndRefreshReservationsData() {
        self.allIndividualReservations.removeAll()
        self.allTeamReservations.removeAll()
        self.isLoading = true

        if personalReservations {
            self.fetchReservations {
                self.isLoading = false
            }
        } else {
            let group = DispatchGroup()

            group.enter()
            self.fetchAppParameters { group.leave() }

            group.enter()
            self.fetchTeamReservations { group.leave() }

            group.notify(queue: .main) {
                self.isLoading = false
            }
        }
    }

    func fetchReservations(completion: @escaping () -> Void) {
        self.isLoading = true

        guard let user = userManager.getUser() else { return }
        guard let userId = user.id else { return }

        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        reservationService.getReservesByUser(userId: userId) { [weak self] result in
            DispatchQueue.main.async {
                defer { dispatchGroup.leave() }

                switch result {
                case .success(let reservations):
                    let innerDispatchGroup = DispatchGroup()

                    for var reservation in reservations {
                        innerDispatchGroup.enter()

                        self?.reservationService.getReservesSlotByUser(space: reservation.slot.space) { [weak self] result in
                            DispatchQueue.main.async {
                                switch result {
                                case .success(let gameSpaces):
                                    if Utils.createDate(from: reservation.date) != nil {
                                        reservation.gamingSpaces = gameSpaces
                                        self?.allIndividualReservations.append(reservation)
                                    }
                                case .failure(let error):
                                    Logger.shared.log("Error al obtener reservas: \(error)")
                                }
                                innerDispatchGroup.leave()
                            }
                        }
                    }

                    innerDispatchGroup.notify(queue: .main) {
                        Logger.shared.log("Reservas obtenidas: \(reservations)")
                    }

                case .failure(let error):
                    Logger.shared.log("Error al obtener reservas: \(error)")
                }
            }
        }

        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }

    func fetchTeamReservations(completion: @escaping () -> Void) {
        guard let userId = userManager.getUser()?.id,
              let team = userManager.getSelectedTeam() else {
            self.isLoading = false
            return
        }

        reservationService.getAllTrainings(teamId: team.id, userId: userId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let reservations):
                    for var reservation in reservations {
                        if Utils.createDate(from: reservation.startDate) != nil {
                            reservation.teamName = team.name
                            self?.allTeamReservations.append(reservation)
                        }
                    }
                    completion()
                case .failure(let error):
                    Logger.shared.log("Error al obtener reservas de equipo: \(error)")
                    completion()
                }
            }
        }
    }

    func getIndividualReservation() -> IndividualReservation {
        return self.individualSelectedInformation!
    }

    func trainingIndividualListCellPressed(individualSelectedInformation: IndividualReservation, optionSelected: TeamReservationCellComponentOptionSelected) {
        self.individualSelectedInformation = individualSelectedInformation
        switch optionSelected {
        case .removeCell:
            self.cancelReservation = true
        case .seeDetails:
            Logger.shared.log("See individual training for \(individualSelectedInformation)")
            self.isSelectTranning = true
        case .editBooking:
            openReservationFlowIfAllowed(editInformation: true)
        }
    }

    func trainingTeamListCellPressed(teamSelectedInformation: EventModel, optionSelected: TeamReservationCellComponentOptionSelected) {
        self.teamSelectedInformation = teamSelectedInformation

        switch optionSelected {
        case .removeCell:
            self.cancelReservation = true
        case .seeDetails:
            Logger.shared.log("See team training for \(teamSelectedInformation)")
            self.isSelectTranning = true
        case .editBooking:
            openReservationFlowIfAllowed(editInformation: true)
        }
    }

    func deleteReservation(isTeamSelected: Bool) {
        if isTeamSelected {
            guard let training = teamSelectedInformation,
                  let trainingId = training.id else { return }

            let isVirtual = training.type.lowercased() == "virtual"
            let reserveId: Int? = isVirtual ? nil : training.reserves?.first?.id

            self.isLoading = true
            reservationService.deleteTraining(trainingId: trainingId, reserveIds: [reserveId ?? 0]) { [weak self] result in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    switch result {
                    case .success:
                        Logger.shared.log("Training eliminado correctamente")
                        self?.allTeamReservations.removeAll()
                        self?.showToastDeleteSuccess = true
                        self?.fetchTeamReservations { self?.isLoading = false }
                        self?.cancelReservation.toggle()
                    case .failure(let error):
                        self?.showToastDeleteFailure = true
                        Logger.shared.log("Error al eliminar el training: \(error.localizedDescription)")
                        self?.cancelReservation.toggle()
                    }
                }
            }
        } else {
            guard let id = individualSelectedInformation?.id else { return }
            self.isLoading = true
            reservationService.deleteReservation(id: String(id)) { [weak self] result in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    switch result {
                    case .success:
                        Logger.shared.log("Success individual deletion")
                        self?.allIndividualReservations.removeAll()
                        self?.showToastDeleteSuccess = true
                        self?.fetchReservations { self?.isLoading = false }
                        self?.cancelReservation.toggle()
                    case .failure(let error):
                        self?.showToastDeleteFailure = true
                        Logger.shared.log("Error al eliminar la reserva individual: \(error.localizedDescription)")
                        self?.cancelReservation.toggle()
                    }
                }
            }
        }
    }
}

// MARK: - Booking Permission Checks — Individual

extension ReservationComponentViewModel {
    
    func userHasDNI() -> Bool {
        guard let user = userManager.getUser() else { return false }
        return !(user.dni ?? "").isEmpty
    }
    
    func userIsValidated() -> Bool {
        guard let user = userManager.getUser() else { return false }
        let validStatuses = ["published", "active"]
        return userHasDNI() && validStatuses.contains(user.status?.lowercased() ?? "")
    }
    
    private func userReservationLimit() -> Int {
        guard let user = userManager.getUser() else { return 1 }
        return user.numberOfBookingsAllowed
    }
    
    func userCanBook() -> Bool {
        return allIndividualReservations.count < userReservationLimit()
    }
}

// MARK: - Booking Permission Checks — Team

extension ReservationComponentViewModel {
    
    func teamCanBook() -> Bool {
        return allTeamReservations.count < teamReservationLimit()
    }

    private func teamReservationLimit() -> Int {
        return trainingsTeamLimit
    }

    func fetchAppParameters(completion: @escaping () -> Void) {
        ParametersService.shared.fetchParameters { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let params):
                    self?.trainingsTeamLimit = params.trainingsTeamLimit
                    Logger.shared.log("trainingsTeamLimit fetched: \(params.trainingsTeamLimit)")
                case .failure(let error):
                    Logger.shared.log("Error fetching app parameters: \(error)")
                }
                completion()
            }
        }
    }
}

// MARK: - DNI & Reservation Flow

extension ReservationComponentViewModel {
    func checkIfDNIExists() {
        let user = userManager.getUser()
        let dni = user?.dni ?? ""
        if dni.isEmpty {
            dniIsMissing = true
        } else {
            dniIsMissing = false
        }
    }

    func setDNIToTheUser(_ dni: String) {
        guard let id = self.userManager.getUser()?.id else { return }
        self.isLoading = true
        ProfileInformation().updateSingleDNIInformationProfile(userId: id, dni: dni) { result in
            DispatchQueue.main.async { [weak self] in
                self?.isLoading = false
                switch result {
                case .success(let profile):
                    Logger.shared.log("Dni actualizado correctamente: \(profile)")
                    self?.userManager.setDNI(dni)
                    self?.dniIsMissing = false
                    self?.isReservationFlowPresented = true
                case .failure(let error):
                    Logger.shared.log("Error al actualizar perfil: \(error.localizedDescription)")
                    self?.dniError = "dni.already.in.use".localized
                }
            }
        }
    }
    
    func openReservationFlowIfAllowed(editInformation: Bool = false) {
        guard userManager.getUser() != nil else {
            noReservationAllowed = true
            return
        }

        // Editing always opens the flow directly
        if editInformation {
            isReservationFlowPresented = true
            return
        }

        if personalReservations {
            // Individual booking
            if userIsValidated() && !userCanBook() {
                noReservationAllowed = true
            } else if !userIsValidated() && !userCanBook() {
                noReservationAllowedWithoutDNI = true
            } else {
                if userHasDNI() {
                    isReservationFlowPresented = true
                } else {
                    dniIsMissing = true
                }
            }
        } else {
            // Team booking — only managers allowed
            guard getUserRol().lowercased() == "manager" else { return }
            if !teamCanBook() {
                noReservationAllowed = true
            } else {
                isReservationFlowPresented = true
            }
        }
    }
    
    func resetScreen() {
        getAndRefreshReservationsData()
        self.teamSelectedInformation = nil
        self.individualSelectedInformation = nil
    }
}
