//
//  CompetitionsViewModel.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 18/10/24.
//


import SwiftUI

class CompetitionsViewModel: ObservableObject {
    @Published var seasonSelected: SeasonsModel?
    @Published var isLoading: Bool = false

    private let competitionsService = CompetitionsService()
    @Published var competitionInformation: [CompetitionData] = []
        
    func initAllSeasons() -> [SeasonsModel] {
        let currentYear = Calendar.current.component(.year, from: Date())
        let years = (2024...currentYear).map { "\($0)" }
        
        var allYearSessons: [SeasonsModel] = []
        for year in years {            
            let season = SeasonsModel(year: year, isOptionSelected: false)
            allYearSessons.append(season)
        }
        
        return allYearSessons
    }
    
    
    func getSeasonInformation() {
        isLoading = true
        competitionInformation = []
        competitionsService.getCompetitions(year: seasonSelected?.year ?? "") { [weak self] result in
            Task { @MainActor [weak self] in
                defer { self?.isLoading = false }
                switch result {
                case .success(let competitions):
                    self?.competitionInformation = competitions.sorted {
                        ($0.game?.priority ?? Int.max) < ($1.game?.priority ?? Int.max)
                    }
                case .failure(let error):
                    Logger.shared.log("Error al obtener reservas de equipo: \(error)")
                }
            }
        }
    }
    
    func getAllInformationLeagues() -> [LeagueModel] {
        let leagueData = [
            ("competitions.municipalLeague".localized,
             "Esports Series Madrid",
             "competitions.subheadings.townLeague".localized,
             "esm"),

            ("competitions.juniorLeague".localized,
             "Esports Series Madrid",
             "competitions.subheadings.junior".localized,
             "junior"),

            ("competitions.stormCircuit".localized,
             "Esports Series Madrid",
             "competitions.subheadings.storm".localized,
             "stormCircuit"),

            ("competitions.otherLeague".localized,
             "Esports Series Madrid",
             "",
             "other")
        ]
        
        return leagueData.compactMap { title, seriesTitle, description, type in
            let allCompetitionsInLeague = filterCompetitonsByType(type: type)
            return allCompetitionsInLeague.isEmpty ? nil : LeagueModel(title: title, seriesTitle: seriesTitle, description: description, allCompetitions: allCompetitionsInLeague)
        }
    }

    
    func filterCompetitonsByType(type: String) -> [CompetitionData] {
        return self.competitionInformation.compactMap { competition in
            (competition.type == type) ? competition : nil
        }
    }
    
//    func selectSeason(withTitle title: String) {
//        if let selectedSeason = competitionsInformation.seasons.first(where: { $0.year == title }) {
//            self.seasonSelected = selectedSeason
//            updateDropdownSelection(selectedTitle: title)
//        }
//    }
    
//    private func updateDropdownSelection(selectedTitle: String) {
//        dropdownOptions = competitionsInformation.seasons.map { season in
//            DropdownSingleSelectionModel(title: season.year, isOptionSelected: season.year == selectedTitle)
//        }
//    }
}
