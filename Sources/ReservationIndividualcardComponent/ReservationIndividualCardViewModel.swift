//
//  ReservationCardViewModel.swift
//  Pods
//
//  Created by Arnau Rivas Rivas on 20/2/25.
//

import SwiftUI

class ReservationIndividualCardViewModel: ObservableObject {
    @Published var reservation: IndividualReservation
    @Published var rotationY: Double = 0
    @Published var isFlipped: Bool = false
    @Published var originalBrightness: CGFloat = UIScreen.main.brightness

    init(reservation: IndividualReservation) {
        self.reservation = reservation
    }
    
    func getReservationConsole() -> String {
        return reservation.gamingSpaces.first?.translations.first?.device ?? ""
    }
    
    func getIfReservationIscenterOrVirtualText() -> String {
        return "ESPORTS CENTER"
    }
    
    func formatTimes() -> String {
        return reservation.times.map { $0.gamingSpaceTimesID?.time ?? "0" }.joined(separator: ", ")
    }
    
    func parseTimeDeleteSeconds(_ time: String) -> String {
        let parts = time.split(separator: ":")
        let hourWithoutSeconds = "\(parts[0]):\(parts[1])"

        return hourWithoutSeconds
    }
    
//    func getAllPlayers() -> [PlayerUsersModel] {
//        guard let allPlayers = reservation.players else { return [] }
//        return allPlayers
//    }
    
    func parseReservationDate() -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"

        if let date = inputFormatter.date(from: reservation.date) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "dd/MM/yyyy"
            let formattedDate = outputFormatter.string(from: date)
            return formattedDate
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
