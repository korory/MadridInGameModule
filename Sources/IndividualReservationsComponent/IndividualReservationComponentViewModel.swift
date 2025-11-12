import SwiftUI

class IndividualReservationComponentViewModel: ObservableObject {
    @Published var isReservationFlowPresented = false
    //@Published var createReservation: Bool = false
    //@Published var seeReservation: Bool = false
    
    @Published var userManager = UserManager.shared

    @Published var isRemoveTraning: Bool = false
    @Published var isSelectTraning: Bool = false

    
    @Published var allIndividualReservations: [IndividualReservation] = []
    @Published var individualSelectedInformation: IndividualReservation?

    @Published var cancelReservation: Bool = false
    @Published var selectedReservation: Reservation?
    
    @Published var dniIsMissing: Bool = false

    @Published var noReservationAllowed: Bool = false
    @Published var noReservationAllowedWithoutDNI: Bool = false

    @Published var isLoading: Bool = true
    @Published var showToastSuccess: Bool = false
    @Published var showToastFailure: Bool = false
    @Published var showToastDeleteSuccess: Bool = false
    @Published var showToastDeleteFailure: Bool = false

    private let reservationService = ReservationService()

    func getAndRefreshReservationsData() {
        self.allIndividualReservations.removeAll()
        self.fetchReservations {
            self.isLoading = false
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
                    
                    // Esperamos que todas las llamadas internas terminen
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

    func getIndividualReservation() -> IndividualReservation {
        return self.individualSelectedInformation!
    }
//    func isSeeReservationButtonPressed() {
//        self.seeReservation.toggle()
//    }
//
//    func isCancelReservationButtonPressed(for reservation: Reservation) {
//        self.selectedReservation = reservation
//        self.cancelReservation.toggle()
//    }
//
//    func isCreateReservationButtonPressed() {
//        self.createReservation.toggle()
//    }

//    func isCellIsPressed(_ optionSelected: IndividualReservationsCellOptions, _ consoleReservation: String, _ dateReservation: String, _ hoursReservation: [String]) {
////        self.reservationModel.consoleSelected = consoleReservation
////        self.reservationModel.dateSelected = dateReservation
////        self.reservationModel.hoursSelected = hoursReservation
//
//        switch (optionSelected) {
//        case .seeReservation:
//            //self.isSeeReservationButtonPressed()
//            break
//        case .cancelReservation:
//            //self.isCancelReservationButtonPressed()
//            break
//        }
//    }
    
    func trainingIndividualListCellPressed (individualSelectedInformation: IndividualReservation, optionSelected: TeamReservationCellComponentOptionSelected) {
        switch optionSelected {
        case .removeCell:
            self.individualSelectedInformation = individualSelectedInformation
            //self.isRemoveTraning = true
            self.cancelReservation = true
        case .seeDetails:
            Logger.shared.log("See individual training for \(individualSelectedInformation)")
            self.individualSelectedInformation = individualSelectedInformation
            self.isSelectTraning = true
            break
        }
    }
    
    func deleteReservation() {
        guard let id = individualSelectedInformation?.id else { return }
        self.isLoading = true
            reservationService.deleteReservation(id: id) { [weak self] result in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    switch result {
                    case .success:
                        Logger.shared.log("Success")
                        self?.allIndividualReservations.removeAll()
                        self?.showToastDeleteSuccess = true
                        self?.fetchReservations {
                            self?.isLoading = false
                        }
                        self?.cancelReservation.toggle()
                    case .failure(let error):
                        self?.isLoading = false
                        self?.showToastDeleteFailure = true
                        Logger.shared.log("Error al eliminar la reserva: \(error.localizedDescription)")
                        self?.cancelReservation.toggle()
                    }
                }
            }
        }
}

extension IndividualReservationComponentViewModel {
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
        guard let id = self.userManager.getUser()?.id else {
            return
        }
        self.isLoading = true
        ProfileInformation().updateSingleDNIInformationProfile(userId: id, dni: dni) { result in
            DispatchQueue.main.async { [weak self] in
                self?.isLoading = false
                switch result {
                case .success(let profile):
                    Logger.shared.log("Dni actualizado correctamente: \(profile)")
                    self?.userManager.setDNI(dni)
                    self?.isReservationFlowPresented = true
                case .failure(let error):
                    Logger.shared.log("Error al actualizar perfil: \(error.localizedDescription)")
                    //TODO: show an error
                }
            }
        }
    }
}
