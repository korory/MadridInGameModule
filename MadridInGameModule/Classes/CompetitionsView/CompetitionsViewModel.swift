//
//  CompetitionsViewModel.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 18/10/24.
//


import SwiftUI

class CompetitionsViewModel: ObservableObject {
    let competitionsInformation: CompetitionsModel
    
    @Published var seasonSelected: SeasonsModel
    @Published var dropdownOptions: [DropdownSingleSelectionModel]
    
    init(competitionsInformation: CompetitionsModel) {
        self.competitionsInformation = competitionsInformation
        self.seasonSelected = competitionsInformation.seasons.first!
        self.dropdownOptions = competitionsInformation.seasons.map { season in
            DropdownSingleSelectionModel(title: season.year, isOptionSelected: season.year == competitionsInformation.seasons.first?.year)
        }
    }
    
    func markFirstOptionDefault(title: String) -> Bool {
        return title == competitionsInformation.seasons.first?.year
    }
    
    func selectSeason(withTitle title: String) {
        if let selectedSeason = competitionsInformation.seasons.first(where: { $0.year == title }) {
            self.seasonSelected = selectedSeason
            updateDropdownSelection(selectedTitle: title)
        }
    }
    
    private func updateDropdownSelection(selectedTitle: String) {
        dropdownOptions = competitionsInformation.seasons.map { season in
            DropdownSingleSelectionModel(title: season.year, isOptionSelected: season.year == selectedTitle)
        }
    }
}
