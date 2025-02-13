//
//  SeeReservationsOrCreateTeamTrainingViewModel.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 15/10/24.
//


import SwiftUI

struct MarkTrainnigDatesAndReservetions: Codable {
    let date: Date
    let individualReservation: Bool
}

class SeeReservationsOrCreateTeamTrainingViewModel: ObservableObject {
    @Published var isDateSelected: Bool = false
    @Published var dateSelected: String = ""
    @Published var isUserMode: Bool = false
    @Published var markedDates: [MarkTrainnigDatesAndReservetions] = []
    @Published var isEditTraning: Bool = false
    @Published var isRemoveTraning: Bool = false
    @Published var isCreateNewTraining: Bool = false
    
    @Published var teamReservationCellInformation: TeamReservation?
    @Published var allReservations: [EventModel] = []
    @Published var teamSelectedInformation: EventModel?

    //@Published var individualReservations: [IndividualReservationModel] = []
    @Published var userManager = UserManager.shared
    
    @Published var isCalendarVisible: Bool = true
    @Published var isTrainingsVisible: Bool = true
    @Published var calendarArrowRotation: Double = 0
    @Published var trainingArrowRotation: Double = 0
    
    @Published var isLoading = true
    
    private let reservationService = ReservationService()
    private let selectedTeam: TeamModelReal?
    
    init(isUserMode: Bool, selectedTeam: TeamModelReal?) {
        self.isUserMode = isUserMode
        self.selectedTeam = selectedTeam
        self.loadAllData()
    }
    
    func loadAllData() {
        if isUserMode {
            self.fetchTeamReservationsByUser {
                self.isLoading = false
            }
        } else {
            self.fetchTeamReservationsByTeam {
                self.isLoading = false
            }
        }
    }
    
    func fetchTeamReservationsByUser(completion: @escaping () -> Void) {
        guard let userId = userManager.getUser()?.id,
              let getAllTeams = userManager.getUser()?.teams else { return }
        
        for team in getAllTeams {
            self.reservationsService(team: team, userId: userId) {
                completion()
            }
        }
        
        reservationService.getReservesByUser(userId: userId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let reservations):
                    for reservation in reservations {
                        if let createDate = Utils.createDate(from: reservation.date) {
                            self?.markedDates.append(MarkTrainnigDatesAndReservetions(date: createDate, individualReservation: true))
                        }
                    }
                    print("Reservas obtenidas: \(reservations)")
                case .failure(let error):
                    print("Error al obtener reservas: \(error)")
                }
            }
        }
    }
    
    func fetchTeamReservationsByTeam(completion: @escaping () -> Void) {
        guard let userId = userManager.getUser()?.id,
              let getTeam = selectedTeam else { return }
        
        self.reservationsService(team: getTeam, userId: userId) {
            completion()
        }
    }
    
    func reservationsService(team: TeamModelReal, userId: String, completion: @escaping () -> Void) {
        reservationService.getAllTrainnings(teamId: team.id, userId: userId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let reservations):
                    for reservation in reservations {
                        if let createDate = Utils.createDate(from: reservation.startDate) {
                            self?.allReservations.append(reservation)
                            self?.markedDates.append(MarkTrainnigDatesAndReservetions(date: createDate, individualReservation: false))
                        }
                    }
                    completion()
                case .failure(let error):
                    print("Error al obtener reservas de equipo: \(error)")
                }
            }
        }
    }
    
    
    // Handle date selection from the calendar
    func handleDateSelection(_ date: String) {
        isDateSelected = true
        // Here you could load reservations for the selected date
    }
    
    // Handle training cell options like removing or editing a reservation
    func handleTrainingOptionSelected(option: TrainingCellOption, reservation: TeamReservationModel) {
        switch option {
        case .removeCell:
            // Handle the removal logic here
            print("Remove training for \(reservation.dateSelected)")
            //teamReservations.removeAll { $0.date.formatted() == reservation.dateSelected }
        case .editTraining:
            // Handle the edit logic
            print("Edit training for \(reservation.dateSelected)")
        case .seeDetails:
            // Handle showing details
            print("See details for \(reservation.dateSelected)")
        }
    }
    
    func trainingTeamListCellPressed (teamSelectedInformation: EventModel, optionSelected: TeamReservationCellComponentOptionSelected) {
        self.teamSelectedInformation = teamSelectedInformation
        
        switch optionSelected {
        case .removeCell:
            //print("Remove Cell for \(teamSelectedInformation.dateSelected)")
            self.isRemoveTraning = true
        case .editTraining:
            //print("Edit Training for \(teamSelectedInformation.dateSelected)")
            self.isEditTraning = true
        case .seeDetails:
            //print("See Details for \(teamSelectedInformation.dateSelected)")
            break
        }
    }
}

enum TrainingCellOption {
    case removeCell, editTraining, seeDetails
}

