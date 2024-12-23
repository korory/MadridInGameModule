//
//  CompetitionsDetailViewModel.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 18/10/24.
//


import SwiftUI

class CompetitionsDetailViewModel: ObservableObject {
    let competitionsInformation: CompetitionsDetailModel
    @Published var optionTabSelected: SplitsModel?
    @Published var selectedTab: Tab = .overview
    
    init(competitionsInformation: CompetitionsDetailModel) {
        self.competitionsInformation = competitionsInformation
        self.optionTabSelected = competitionsInformation.allSplitsAvailable.first!
    }
    
    // Lógica para verificar si la primera opción debe ser marcada por defecto
    func markFirstOptionDefault(title: String) -> Bool {
        return title == competitionsInformation.allSplitsAvailable.first?.title
    }
    
    // Lógica para seleccionar un split
    func selectOption(option: DropdownSingleSelectionModel) {
        if let selectedModel = competitionsInformation.allSplitsAvailable.first(where: { $0.title == option.title }) {
            self.optionTabSelected = selectedModel
        }
    }
}
