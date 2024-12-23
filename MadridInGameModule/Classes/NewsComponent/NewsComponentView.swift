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
            Color.black
                .ignoresSafeArea(edges: .all)
            VStack {
                titleAndPlusButtonBanner
                if viewModel.allNews.isEmpty {
                    noNewsComponent
                } else {
                    allNewsListComponent
                }
            }
            
            CustomPopup(isPresented: Binding(
                get: { viewModel.createNewNews },
                set: { viewModel.createNewNews = $0 }
            )) {
                CreateOrEditNewsComponentView(createNew: true) {
                    self.viewModel.createNewNews = false
                } publishAction: { newModel in
                    self.viewModel.createNewNews = false
                    self.viewModel.allNews.append(newModel)
                }
                
            }
            .transition(.scale)
            .zIndex(1)
            
            CustomPopup(isPresented: Binding(
                get: { viewModel.editNew },
                set: { viewModel.editNew = $0 }
            )) {
                CreateOrEditNewsComponentView(createNew: false, newsInformation: viewModel.selectedNew) {
                    self.viewModel.editNew = false
                } publishAction: { newModel in
                    self.viewModel.editNew = false
                    self.viewModel.editNewsToArray(newSelected: newModel)
                }
                
            }
            .transition(.scale)
            .zIndex(1)
            
            CustomPopup(isPresented: Binding(
                get: { viewModel.deleteNews },
                set: { viewModel.deleteNews = $0 }
            )) {
                CancelOrDeleteComponent(title: "ELIMINAR NOTICIA", subtitle: "¿Quieres eliminar la noticia titulada \(self.viewModel.selectedNew?.title ?? "")") {
                    self.viewModel.deleteNews = false
                } aceptedAction: {
                    self.viewModel.deleteNewsToArray()
                    self.viewModel.deleteNews = false
                    //TODO: Delete reservation to the Backend
                }
                
            }
            .transition(.scale)
            .zIndex(1)
        }
    }
}

extension NewsComponentView {
    private var titleAndPlusButtonBanner: some View {
        HStack {
            Text("NOTICIAS")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(Color.white)
            
            Spacer()
            
            Button {
                self.viewModel.createNewNews = true
            } label: {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .foregroundStyle(Color.cyan)
            }
        }
        .padding()
    }
    
    private var noNewsComponent: some View {
        VStack {
            Spacer()
            Text("No hay noticias actualmente")
                .font(.body)
                .foregroundStyle(Color.gray)
            Spacer()
        }
    }
    
    private var allNewsListComponent: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.allNews, id: \.id) { news in
                    NewsCellComponentView(news: news, editNews: { selectedNews in
                        self.viewModel.selectedNew = selectedNews
                        self.viewModel.editNew = true
                    }) { selectedNews in
                        self.viewModel.selectedNew = selectedNews
                        self.viewModel.deleteNews = true
                    }
                    
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 400, height: 4)
                        .foregroundStyle(Color.white.opacity(0.4))
                }
            }
            .padding()
        }
    }
}
