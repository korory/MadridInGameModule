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
    
    
    @Published var noReservationAllowed: Bool = false

    @Published var isLoading: Bool = true

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

        let userId = user.id
        
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
                                    if let createDate = Utils.createDate(from: reservation.date) {
                                        reservation.gamingSpaces = gameSpaces
                                        self?.allIndividualReservations.append(reservation)
                                    }
                                    
                                case .failure(let error):
                                    print("Error al obtener reservas: \(error)")
                                }
                                innerDispatchGroup.leave()
                            }
                        }
                    }
                    
                    // Esperamos que todas las llamadas internas terminen
                    innerDispatchGroup.notify(queue: .main) {
                        print("Reservas obtenidas: \(reservations)")
                    }

                case .failure(let error):
                    print("Error al obtener reservas: \(error)")
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
            self.isRemoveTraning = true
        case .seeDetails:
            print("See individual training for \(individualSelectedInformation)")
            self.individualSelectedInformation = individualSelectedInformation
            self.isSelectTraning = true
            break
        }
    }
    
//    func deleteReservation() {
//        guard let reservation = selectedReservation, let id = reservation.id else { return }
//        
//            isLoading = true
//            reservationService.deleteReservation(id: id) { [weak self] result in
//                DispatchQueue.main.async {
//                    self?.isLoading = false
//                    switch result {
//                    case .success:
//                        print("Success")
//                        //self?.fetchReservations()
//                        //self?.cancelReservation.toggle()
//                        //self?.reservations.removeAll { $0.id == reservation.id }
//                    case .failure(let error):
//                        print("Error al eliminar la reserva: \(error.localizedDescription)")
//                        //self?.cancelReservation.toggle()
//                    }
//                }
//            }
//        }
}
