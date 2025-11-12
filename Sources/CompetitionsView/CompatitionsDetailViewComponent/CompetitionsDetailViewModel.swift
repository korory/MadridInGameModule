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
        if let firstSplit = competitionsInformation.splits?.first {
            self.optionTabSelected = firstSplit
        } else {
            Logger.shared.log("No splits found for this competition", type: .error)
        }
    }
}
