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
            Color.black
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
            }
        }
    }
}

extension CompetitionsView {
    private var titleBanner: some View {
        Text("COMPETICIONES")
            //.font(.customFont(size: 24))
            //.font(.title)
            //.fontWeight(.bold)
            .foregroundColor(.white)
            .padding(.leading, 10)
            .padding(.bottom, 1)
    }
    
    private var dropdownSplitSelectorComponent: some View {
        let options = viewModel.initAllSeasons().map { DropdownSingleSelectionModel(title: $0.year, isOptionSelected: false) }
        
        return DropdownSingleSelectionComponentView(options: options, onOptionSelected: { optionSelected in
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
