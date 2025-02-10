import SwiftUI

class IndividualReservationComponentViewModel: ObservableObject {
    @Published var createReservation: Bool = false
    @Published var seeReservation: Bool = false
    @Published var cancelReservation: Bool = false
    @Published var reservationModel: ReservationQRModel
    @Published var reservations: [Reservation] = []
    @Published var selectedReservation: Reservation?
    @Published var isLoading: Bool = false

    private let reservationService = ReservationService()

    init(reservationModel: ReservationQRModel) {
        self.reservationModel = reservationModel
        fetchReservations()
    }

    func fetchReservations() {
//        reservationService.getReservesByUser(userId: "f7a09e83-281e-4bb4-952a-e5ae40c99105") { [weak self] result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let reservations):
//                    self?.reservations = reservations
//                    print("Reservas obtenidas: \(reservations)")
//                case .failure(let error):
//                    print("Error al obtener reservas: \(error)")
//                }
//            }
//        }
    }

    func isSeeReservationButtonPressed() {
        self.seeReservation.toggle()
    }

    func isCancelReservationButtonPressed(for reservation: Reservation) {
        self.selectedReservation = reservation
        self.cancelReservation.toggle()
    }

    func isCreateReservationButtonPressed() {
        self.createReservation.toggle()
    }

    func isCellIsPressed(_ optionSelected: IndividualReservationsCellOptions, _ consoleReservation: String, _ dateReservation: String, _ hoursReservation: [String]) {
        self.reservationModel.consoleSelected = consoleReservation
        self.reservationModel.dateSelected = dateReservation
        self.reservationModel.hoursSelected = hoursReservation

        switch (optionSelected) {
        case .seeReservation:
            self.isSeeReservationButtonPressed()
        case .cancelReservation:
            //self.isCancelReservationButtonPressed()
            break
        }
    }
    
    func deleteReservation() {
        guard let reservation = selectedReservation, let id = reservation.id else { return }
        
            isLoading = true
            reservationService.deleteReservation(id: id) { [weak self] result in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    switch result {
                    case .success:
                        //self?.fetchReservations()
                        self?.cancelReservation.toggle()
                        //self?.reservations.removeAll { $0.id == reservation.id }
                    case .failure(let error):
                        print("Error al eliminar la reserva: \(error.localizedDescription)")
                        self?.cancelReservation.toggle()
                    }
                }
            }
        }
}
