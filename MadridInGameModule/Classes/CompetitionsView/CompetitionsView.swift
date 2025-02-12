//
//  CompetitionsView.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 17/10/24.
//

import SwiftUI

struct CompetitionsView: View {
    @StateObject var viewModel: CompetitionsViewModel
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.black, Color.black, Color.white.opacity(0.15)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(.all)
            ScrollView {
                VStack (alignment: .leading){
                    titleBanner
                    dropdownSplitSelectorComponent
                    if !viewModel.compatitionInformation.isEmpty {
                        leaguesInformation
                    }
                    Spacer()
                }
                .onAppear {
                    let currentYear = Calendar.current.component(.year, from: Date())
                    
                    if viewModel.seasonSelected == nil, let allSeasons = viewModel.initAllSeasons().first(where: { $0.year == String(currentYear) }) {
                        viewModel.seasonSelected = SeasonsModel(year: allSeasons.year, isOptionSelected: true)
                        viewModel.getSeasonInformation()
                    }
                }
            }
        }
    }
}

extension CompetitionsView {
    private var titleBanner: some View {
        Text("COMPETICIONES")
            .font(.custom("Madridingamefont-Regular", size: 24))
            .foregroundColor(.white)
            .padding(.leading, 20)
            .padding(.bottom, 7)
            .padding(.top, 5)
    }
    
    private var dropdownSplitSelectorComponent: some View {
        let currentYear = Calendar.current.component(.year, from: Date())
        
        let options = viewModel.initAllSeasons().map { season -> DropdownSingleSelectionModel in
            let isSelected = season.year == String(currentYear)
            return DropdownSingleSelectionModel(title: season.year, isOptionSelected: isSelected)
        }
        
        return DropdownSingleSelectionComponentView(options: options, textTop: "Temporada", onOptionSelected: { optionSelected in
            self.viewModel.seasonSelected = SeasonsModel(year: optionSelected.title, isOptionSelected: optionSelected.isOptionSelected)
            viewModel.getSeasonInformation()
        })
        .padding(.leading, 10)
        .padding(.trailing, 10)
    }
    
    private var leaguesInformation: some View {
        VStack(spacing: 10) {
            ForEach(viewModel.getAllInformationLeagues()) { competitonInformation in
                VStack {
                    CompatitionsCarouselComponentView(leagueInformation: competitonInformation)
                        .padding()
                    
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 400, height: 4)
                        .foregroundStyle(Color.white.opacity(0.4))
                }
            }
        }
        
    }
}
