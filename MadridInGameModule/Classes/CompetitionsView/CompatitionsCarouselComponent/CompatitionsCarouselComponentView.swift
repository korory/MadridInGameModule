//
//  CompatitionsCarouselComponentView.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 17/10/24.
//

import SwiftUI

struct CompatitionsCarouselComponentView: View {
    let leagueInformation: LeagueModel
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea(.all)
            VStack (alignment: .leading, spacing: 20){
                titleBanner
                if !leagueInformation.description.isEmpty {
                    subtitleBanner
                }
                carrouselComponent
                Spacer()
            }
        }
    }
}

extension CompatitionsCarouselComponentView {
    private var titleBanner: some View {
        VStack (spacing: 12){
            Text(leagueInformation.title)
                .font(.system(size: 25).weight(.bold))
                .foregroundStyle(Color.white)
            
            Text(leagueInformation.seriesTitle)
                .font(.system(size: 17).weight(.bold))
                .foregroundStyle(Color.gray)
        }
    }
    
    private var subtitleBanner: some View {
        Text(leagueInformation.description)
            .font(.body)
            .foregroundStyle(Color.white)
    }
    
    private var carrouselComponent: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(leagueInformation.competitions, id: \.id) { competitonInformation in
                    VStack {
                        NavigationLink(destination: CompatitionsDetailViewComponentView(viewModel: CompetitionsDetailViewModel(competitionsInformation: competitonInformation))) {
                            Image(uiImage: UIImage(named: "imageCompetitionCarrouselImage")!)
                                .resizable()
                                .frame(width: 280, height: 470)
                                .cornerRadius(15)
                        }
                    }
                }
            }
        }
    }
}

