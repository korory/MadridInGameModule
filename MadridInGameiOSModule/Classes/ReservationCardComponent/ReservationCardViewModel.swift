//
//  ReservationCardViewModel.swift
//  Pods
//
//  Created by Arnau Rivas Rivas on 13/2/25.
//


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
    
    func checkIfReservationIsVirtual() -> Bool {
        //If reserves is empty that means that the reserve is online

        guard let reservationLocal = reservation.reserves else { return false }
        
        if reservationLocal.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    func getIfReservationIscenterOrVirtualText() -> String {
        if checkIfReservationIsVirtual() {
            return "VIRTUAL"
        } else {
            return "ESPORTS CENTER"
        }
    }
    
    func getAllReservationTimes() -> [String] {
        
        if let allReservations = self.reservation.reserves {
            
            if allReservations.isEmpty {
                return [parseTimeDeleteSeconds(self.reservation.time)]
            }
                var allHours: [String] = []
                
                for reservation in allReservations {
                    guard let allReservesTimes = reservation.times else { return [] }
                    
                    for reservationTime in allReservesTimes {
                        allHours.append(parseTimeDeleteSeconds(reservationTime.gamingSpaceTimesID?.time ?? ""))
                    }
                }
            
                return allHours
            
        } else {
            return [parseTimeDeleteSeconds(self.reservation.time)]
        }
    }
    
    func parseTimeDeleteSeconds(_ time: String) -> String {
        let parts = time.split(separator: ":")
        let hourWithoutSeconds = "\(parts[0]):\(parts[1])"

        return hourWithoutSeconds
    }
    
    func getAllPlayers() -> [PlayerUsersModel] {
        guard let allPlayers = reservation.players else { return [] }
        return allPlayers
    }
    
    func parseReservationDate() -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"

        if let date = inputFormatter.date(from: reservation.startDate) {
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
