//
//  DetailsTournamentView.swift
//  Pods
//
//  Created by Arnau Rivas Rivas on 11/2/25.
//

import SwiftUI

struct DetailsTournamentView: View {
    var title: String
    var content: [TournamentModel]?

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.white.opacity(0.2), Color.white.opacity(0.4)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(.all)
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text(title.uppercased())
                        .font(.madridInGameiOSFont(size: 20))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 5)
                    
                    if let content, !content.isEmpty {
                        ForEach(content) { singleContent in
                            TournamentCellView(date: singleContent.date ?? "", name: singleContent.name ?? "", targetURL: singleContent.link ?? "", statusString: singleContent.status ?? "")
                        }
                    } else {
                        Text("competitions.subheadings.notFound".localized)
                            .foregroundColor(.white)
                            .padding()
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
