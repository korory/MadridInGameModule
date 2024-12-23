//
//  CreateNewTrainingViewModel.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 16/10/24.
//


import SwiftUI

class CreateNewTrainingViewModel: ObservableObject {
    // Estados observables
    @Published var initialReservationDone: Bool = false
    @Published var locationSelected: DropdownSingleSelectionModel = DropdownSingleSelectionModel(title: "", isOptionSelected: false)
    @Published var hoursSelected: [String] = []
    @Published var isReservationValid: Bool = false
    @Published var consoleSelected: String = ""
    @Published var notes: String = ""
    @Published var playersSelected: [String] = []
    
    let dateSelected: String
    let hoursReservation: [String]
    let consoleReservation: [String]
    
    init(dateSelected: String = "", availableHoursReservation: [String] = ["14:00", "15:00", "16:00", "17:00", "18:00", "19:00"], availableConsoleReservation: [String] = ["PC", "Xbox", "PlayStation", "Tablet"]) {
        self.dateSelected = dateSelected
        self.hoursReservation = availableHoursReservation
        self.consoleReservation = availableConsoleReservation
    }
    
    // Función para manejar la selección de una ubicación
    func selectLocation(option: DropdownSingleSelectionModel) {
        self.locationSelected = option
    }
    
    func addRemoveHours(hour: String) {
        if let index = hoursSelected.firstIndex(of: hour) {
            hoursSelected.remove(at: index)
            if hoursSelected.isEmpty {
                consoleSelected = ""
            }
        } else {
            if hoursSelected.count < 2 {
                hoursSelected.append(hour)
            }
        }
        isReservationValid = false
    }
    
    func addRemoveNewPlayer(namePlayer: String) {
        if !playersSelected.contains(namePlayer) {
            playersSelected.append(namePlayer)
        } else {
            playersSelected.removeAll { $0 == namePlayer }
        }
    }
    
    // Función para seleccionar consola
    func selectConsole(console: String) {
        self.consoleSelected = console
    }
    
    // Función para descartar
    func discard() {
        self.initialReservationDone = false
        self.locationSelected = DropdownSingleSelectionModel(title: "", isOptionSelected: false)
        self.hoursSelected.removeAll()
        self.consoleSelected = ""
        self.notes = ""
    }
    
    // Función para continuar con la reserva
    func continueReservation() {
        self.initialReservationDone = true
    }
    
    func reservationCall() {
        if (dateSelected != "" && !hoursSelected.isEmpty && consoleSelected != "") {
            print("Reservation")
            isReservationValid = true
        }
    }
}
