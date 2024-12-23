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
                    dropdownTitle
                    dropdownSplitSelectorComponent
                    leaguesInformation
                    Spacer()
                }
            }
        }
    }
}

extension CompetitionsView {
    private var titleBanner: some View {
        Text("COMPETICIONES")
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .shadow(color: Color.black.opacity(0.5), radius: 5)
            .padding(.leading, 10)
            .padding(.bottom, 5)
    }
    
    private var dropdownTitle: some View {
        VStack (alignment: .leading, spacing: 28){
            TextWithUnderlineComponent(title: "Season", underlineColor: Color.cyan)
                .padding(.leading, 15)
        }
    }
    
    private var dropdownSplitSelectorComponent: some View {
        let options = viewModel.competitionsInformation.seasons.map { DropdownSingleSelectionModel(title: $0.year, isOptionSelected: viewModel.markFirstOptionDefault(title: $0.year)) }
        
        return DropdownSingleSelectionComponentView(options: options, onOptionSelected: { optionSelected in
            if let selectedModel = viewModel.competitionsInformation.seasons.first(where: { $0.year == optionSelected.title }) {
                self.viewModel.seasonSelected = selectedModel
            }
        })
        .padding()
    }
    
    private var leaguesInformation: some View {
        VStack(spacing: 10) {
            ForEach(viewModel.seasonSelected.mundialLeague, id: \.id) { competitonInformation in
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
