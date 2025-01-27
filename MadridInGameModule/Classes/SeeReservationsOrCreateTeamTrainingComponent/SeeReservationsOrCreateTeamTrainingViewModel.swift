//
//  SeeReservationsOrCreateTeamTrainingViewModel.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 15/10/24.
//


import SwiftUI

class SeeReservationsOrCreateTeamTrainingViewModel: ObservableObject {
    @Published var isDateSelected: Bool = false
    @Published var dateSelected: String = ""
    @Published var isUserMode: Bool = false
    @Published var markedDates: [Date] = []
    @Published var isEditTraning: Bool = false
    @Published var isRemoveTraning: Bool = false
    @Published var isCreateNewTraining: Bool = false
    
    @Published var teamReservationCellInformation: TeamReservation?
    
    /* // Mock data for team training reservations
     @Published var teamReservations: [TeamReservationModel] = mockTeamReservationCellViewModel
     
     // Mock data for individual training reservations
     @Published var individualReservations: [IndividualReservationModel] = mockIndividualReservationCellViewModel*/
    
    @Published var teamReservations: [TeamReservation] = []
    @Published var individualReservations: [IndividualReservationModel] = []
    
    private let reservationService = ReservationService()
    
    init(isUserMode: Bool, markedDates: [Date]) {
        self.isUserMode = isUserMode
        self.markedDates = markedDates
    }
    
    func fetchTeamReservations() {
        let teamId = "6d8fd820-5aa4-479a-89e9-1f85c906f189"
        reservationService.getReservesByTeam(teamId: teamId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let reservations):
                    self?.teamReservations = reservations
                case .failure(let error):
                    print("Error al obtener reservas de equipo: \(error)")
                }
            }
        }
    }
    
    func fetchTeamReservationsByUser() {
        let teamId = "6d8fd820-5aa4-479a-89e9-1f85c906f189"
        let userId = "bbb4b8e6-8dc3-4fe2-b029-43a5c55b071a"
        reservationService.getReservesByTeamAndUser(teamId: teamId, userId: userId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let reservations):
                    self?.teamReservations = reservations
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
            teamReservations.removeAll { $0.date.formatted() == reservation.dateSelected }
        case .editTraining:
            // Handle the edit logic
            print("Edit training for \(reservation.dateSelected)")
        case .seeDetails:
            // Handle showing details
            print("See details for \(reservation.dateSelected)")
        }
    }
    
    func trainingTeamListCellPressed (teamSelectedInformation: TeamReservation, optionSelected: TeamReservationCellComponentOptionSelected) {
        
        teamReservationCellInformation = teamSelectedInformation
        
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

