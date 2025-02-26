//
//  NewsComponentView.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 17/10/24.
//

import SwiftUI

struct NewsComponentView: View {
    @StateObject var viewModel: NewsViewModel
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.black, Color.black, Color.white.opacity(0.15)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(.all)
            
            if viewModel.isLoading {
                LoadingView(message: "Cargando Noticias....")
                    .onAppear {
                        viewModel.getAllNews()
                    }
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
                        .presentationDetents([.medium, .large])
                }
                .onDisappear {
                    self.viewModel.isLoading = false
                }
            }
            
            
//            CustomPopup(isPresented: Binding(
//                get: { viewModel.createNewNews },
//                set: { viewModel.createNewNews = $0 }
//            )) {
//                CreateOrEditNewsComponentView(createNew: true) {
//                    self.viewModel.createNewNews = false
//                } publishAction: { newModel in
//                    self.viewModel.createNewNews = false
//                    self.viewModel.allNews.append(newModel)
//                }
//                
//            }
//            .transition(.scale)
//            .zIndex(1)
//            
//            CustomPopup(isPresented: Binding(
//                get: { viewModel.editNew },
//                set: { viewModel.editNew = $0 }
//            )) {
//                CreateOrEditNewsComponentView(createNew: false, newsInformation: viewModel.selectedNew) {
//                    self.viewModel.editNew = false
//                } publishAction: { newModel in
//                    self.viewModel.editNew = false
//                    self.viewModel.editNewsToArray(newSelected: newModel)
//                }
//                
//            }
//            .transition(.scale)
//            .zIndex(1)
//            
//            CustomPopup(isPresented: Binding(
//                get: { viewModel.deleteNews },
//                set: { viewModel.deleteNews = $0 }
//            )) {
//                CancelOrDeleteComponent(title: "ELIMINAR NOTICIA", subtitle: "¿Quieres eliminar la noticia titulada \(self.viewModel.selectedNew?.title ?? "")") {
//                    self.viewModel.deleteNews = false
//                } aceptedAction: {
//                    self.viewModel.deleteNewsToArray()
//                    self.viewModel.deleteNews = false
//                    //TODO: Delete reservation to the Backend
//                }
//                
//            }
//            .transition(.scale)
//            .zIndex(1)
        }
    }
}

extension NewsComponentView {
    private var titleAndPlusButtonBanner: some View {
        HStack {
            Text("NOTICIAS")
                .font(.custom("Madridingamefont-Regular", size: 25))
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
//
//            Button {
//                self.viewModel.createNewNews = true
//            } label: {
//                Image(systemName: "plus.circle.fill")
//                    .resizable()
//                    .frame(width: 40, height: 40)
//                    .clipShape(Circle())
//                    .foregroundStyle(Color.cyan)
//            }
        }
        .padding()
    }
    
    private var noNewsComponent: some View {
        VStack {
            Spacer()
            Text("No hay noticias en este equipo actualmente")
                .font(.custom("Madridingamefont-Regular", size: 15))
                .foregroundStyle(Color.gray)
                .padding()
            Spacer()
        }
    }
    
    private var allNewsListComponent: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.allNews) { news in
                    NewsCellComponentView(viewModel: NewsCellViewModel(news: news)) { newsSelected in
                        self.viewModel.setNewsSelected(newsSelected)
                    }
                    .padding(.bottom, 5)
                }
            }
        }
        .padding(.leading, 10)
        .padding(.trailing, 10)
    }
}
