//
//  CompetitionsViewModel.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 18/10/24.
//


import SwiftUI

class CompetitionsViewModel: ObservableObject {
    @Published var seasonSelected: SeasonsModel?
    
    private let competitionsService = CompetitionsService()
    @Published var compatitionInformation: [CompetitionData] = []
        
    func initAllSeasons() -> [SeasonsModel] {
        let years = ["2024", "2025", "2026"]
        
        var allYearSessons: [SeasonsModel] = []
        for year in years {            
            let season = SeasonsModel(year: year, isOptionSelected: false)
            allYearSessons.append(season)
        }
        
        return allYearSessons
    }
    
    
    func getSeasonInformation() {
        competitionsService.getCompetitions(year: seasonSelected?.year ?? "") { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let competitions):
                    self?.compatitionInformation = competitions
                case .failure(let error):
                    print("Error al obtener reservas de equipo: \(error)")
                }
            }
        }
    }
    
    func getAllInformationLeagues() -> [LeagueModel]{
        let leagueData = [
            ("Liga Municipal", "Esports Series Madrid", "Madrid in Game es la apuesta del Ayuntamiento de Madrid para elevar el talento amateur de los Esports con la creación de las competiciones: Esports Series Madrid. Constan de dos temporadas al año en las que podrás enfrentarte a los mejores jugadores en un entorno de juego seguro y óptimo.", "esm"),
            ("Liga Municipal Junior", "Esports Series Madrid", "El equivalente de la Esports Series Madrid para colegios e institutos de la ciudad. La ESM Junior Esports es tu puerta de entrada para que puedas participar con tu centro educativo en la liga municipal junior de League of Legends y Rocket League.", "junior"),
            ("Circuito Tormenta", "Esports Series Madrid", "Las Esports Series Madrid de Madrid in Game serán parada oficial del Circuito de Tormenta. Contarán con las competiciones de League of Legends y Valorant, además de disputarse una gran Final presencial. Los torneos otorgarán puntos para el ranking general del Circuito de Tormenta del Split correspondiente.", "stormCircuit"),
            ("Otras competiciones", "Esports Series Madrid", "", "other")
        ]
        
        return leagueData.map { title, seriesTitle, description, type in
            LeagueModel(title: title, seriesTitle: seriesTitle, description: description, allCompetitions: filterCompetitonsByType(type: type))
        }
    }
    
    func filterCompetitonsByType(type: String) -> [CompetitionData] {
        return self.compatitionInformation.compactMap { competition in
            (competition.game?.type == type) ? competition : nil
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
