import SwiftUI

class ReservationCardViewModel: ObservableObject {
    @Published var reservation: EventModel
    @Published var rotationY: Double = 0
    @Published var isFlipped: Bool = false
    @Published var originalBrightness: CGFloat = UIScreen.main.brightness
    @Published var environmentManager = EnvironmentManager()

    init(reservation: EventModel) {
        self.reservation = reservation
    }

    // MARK: - Reserve del usuario logueado

    var myReserve: Reserve? {
        guard let userId = UserManager.shared.getUser()?.id,
              let reserves = reservation.reserves else { return nil }
        return reserves.first(where: { $0.user == userId }) ?? reserves.first
    }

    func checkIfReservationIsVirtual() -> Bool {
        guard let reservationLocal = reservation.reserves else { return false }
        return reservationLocal.isEmpty
    }

    func getIfReservationIscenterOrVirtualText() -> String {
        if checkIfReservationIsVirtual() {
            return "VIRTUAL"
        } else {
            return "ESPORTS MADRID CENTER"
        }
    }

    func getAllReservationTimes() -> [String] {
        // Si es virtual, devolver la hora del training
        if checkIfReservationIsVirtual() {
            return [parseTimeDeleteSeconds(reservation.time)]
        }

        // Usar la reserve del usuario logueado
        guard let reserve = myReserve,
              let times = reserve.times else {
            return [parseTimeDeleteSeconds(reservation.time)]
        }

        return times.compactMap { $0.gamingSpaceTimesID?.time }
            .map { parseTimeDeleteSeconds($0) }
    }

    func parseTimeDeleteSeconds(_ time: String) -> String {
        let parts = time.split(separator: ":")
        guard parts.count >= 2 else { return time }
        return "\(parts[0]):\(parts[1])"
    }

    func getAllPlayers() -> [PlayerUsersModel] {
        return reservation.players ?? []
    }

    func parseReservationDate() -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"

        if let date = inputFormatter.date(from: reservation.startDate) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "dd/MM/yyyy"
            return outputFormatter.string(from: date)
        }

        return "No Fecha"
    }

    func handleDragChange(_ value: DragGesture.Value) {
        rotationY = Double(value.translation.width / 5)
    }

    func handleDragEnd() {
        withAnimation {
            if abs(rotationY) > 90 {
                isFlipped.toggle()
            }
            rotationY = 0
        }
    }
}
