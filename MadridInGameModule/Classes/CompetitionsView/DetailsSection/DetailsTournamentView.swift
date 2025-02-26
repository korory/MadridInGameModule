//
//  DetailsTournamentView.swift
//  Pods
//
//  Created by Arnau Rivas Rivas on 11/2/25.
//

import SwiftUI

struct DetailsTournamentView: View {
    var title: String
    var content: [TournamentModel]
    var image: String
    var environmentManager = EnvironmentManager()
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.white.opacity(0.2), Color.white.opacity(0.4)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(.all)
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
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
                                .frame(height: 100)
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
                    
                    Text(title.uppercased())
                        .font(.custom("Madridingamefont-Regular", size: 20))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 5)
                    
                    ForEach(content) { singleContent in
                        TournamentCellView(date: singleContent.date ?? "", name: singleContent.name ?? "", statusString: singleContent.status ?? "")
                    }
                    
                    Spacer()
                }
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .padding(.bottom)
            }
        }
    }
}
