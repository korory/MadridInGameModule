//
//  CompetitionsCarouselComponentView.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 17/10/24.
//

import SwiftUI

struct CompetitionsCarouselComponentView: View {
    let leagueInformation: LeagueModel
    let environmentManager = EnvironmentManager()
    
    var body: some View {
        ZStack {
            Color.clear
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

extension CompetitionsCarouselComponentView {
    private var titleBanner: some View {
        VStack (alignment: .leading, spacing: 12){
            Text(leagueInformation.title)
                .font(.madridInGameiOSFont(size: 24))
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
                ForEach(leagueInformation.allCompetitions) { competitionInformation in
                    VStack {
                        NavigationLink(destination: CompetitionsDetailViewComponentView(viewModel: CompetitionsDetailViewModel(competitionsInformation: competitionInformation))) {
                            loadImage(for: competitionInformation)
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func loadImage(for competition: CompetitionData) -> some View {
        if let image = competition.game?.image {
            AsyncImage(url: URL(string: "\(environmentManager.getBaseURL())/assets/\(image)")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 50, height: 50)
                        .tint(.purple)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(15)
                        .frame(maxWidth: 250, maxHeight: 450)
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .cornerRadius(15)
                        .frame(width: 280, height: 470)
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
        } else {
            Image(systemName: "photo")
                .resizable()
                .cornerRadius(15)
                .frame(width: 280, height: 470)
                .foregroundColor(.gray)
        }
    }
}

