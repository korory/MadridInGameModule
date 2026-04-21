//
//  NewsComponentView.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 17/10/24.
//

import SwiftUI

struct NewsComponentView: View {
    @StateObject var viewModel = NewsViewModel()
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.black, Color.black, Color.white.opacity(0.15)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(.all)
            
            if viewModel.isLoading {
                LoadingView(message: "Cargando Noticias...")
            } else {
                VStack {
                    titleAndPlusButtonBanner
                    if viewModel.allNews.isEmpty {
                        noNewsComponent
                    } else {
                        allNewsListComponent
                    }
                }
                .sheet(isPresented: self.$viewModel.newSelected) {
                    NewsFlowComponent(news: self.viewModel.newsSelected)
                        .zIndex(1)
                }

                .onDisappear {
                    self.viewModel.isLoading = false
                }
            }
        }
    }
}

extension NewsComponentView {
    private var titleAndPlusButtonBanner: some View {
        HStack {
            Text("dashboard.teams.teamAreas.news.newsListTitle".localized)
                .font(.madridInGameiOSFont(size: 25))
                .foregroundStyle(Color.white)
            
            Spacer()
            
            Button {
                self.viewModel.getAllNews()
            } label: {
                Image(systemName: "arrow.clockwise.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 28, height: 28)
                    .foregroundColor(.cyan)
            }
        }
        .padding()
    }
    
    private var noNewsComponent: some View {
        VStack {
            Spacer()
            Text("dashboard.teams.teamAreas.news.noNewsList".localized)
                .font(.madridInGameiOSFont(size: 15))
                .foregroundStyle(Color.gray)
                .padding()
            Spacer()
        }
    }
    
    private var allNewsListComponent: some View {
        ScrollView {
            //LazyVStack {
                ForEach(viewModel.allNews) { news in
                    NewsCellComponentView(viewModel: NewsCellViewModel(news: news)) { newsSelected in
                        self.viewModel.setNewsSelected(newsSelected)
                    }
                    .padding(.bottom, 5)
                }
            //}
        }
        .padding(.leading, 10)
        .padding(.trailing, 10)
    }
}
