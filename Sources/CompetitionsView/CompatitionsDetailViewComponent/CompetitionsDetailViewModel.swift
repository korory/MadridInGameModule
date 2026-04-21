//
//  CompetitionsDetailViewModel.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 18/10/24.
//


import SwiftUI

class CompetitionsDetailViewModel: ObservableObject {
    let competitionsInformation: CompetitionData//CompetitionsDetailModel
    @Published var optionTabSelected: SplitModel?
    @Published var selectedTab: Tab = .overview
    @Published var isSplitVisible: Bool = true
    @Published var trainingArrowRotation: Double = 0

    init(competitionsInformation: CompetitionData) {
        self.competitionsInformation = competitionsInformation
    }
    
    func getFirstOptionSelected() {
        selectedTab = .overview
        guard let splits = competitionsInformation.splits, !splits.isEmpty else {
            Logger.shared.log("No splits found for this competition", type: .error)
            return
        }
        let activeSplit = splits.first { $0.active == true } ?? splits.first
        self.optionTabSelected = activeSplit
    }
}
