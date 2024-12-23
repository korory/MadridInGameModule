//
//  NewsCellComponentView.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 17/10/24.
//

import SwiftUI

struct NewsCellComponentView: View {
    let news: NewsModel
    let editNews:(NewsModel) -> Void
    let deleteNew:(NewsModel) -> Void
    
    var body: some View {
        VStack (alignment: .leading, spacing: 28){
            titleBanner
            subtitleBanner
            imageBanner
            editOrDeleteNewsComponent
        }
    }
}

extension NewsCellComponentView {
    private var titleBanner: some View {
        Text(news.title)
            .font(.largeTitle)
            .foregroundStyle(Color.white)
    }
    
    private var subtitleBanner: some View {
        ScrollView {
            Text(news.description)
                .font(.body)
                .foregroundStyle(Color.white)
                .lineLimit(nil)
        }
        .frame(maxHeight: 120)
    }
    
    private var imageBanner: some View {
        Image(uiImage: news.image)
            .resizable()
            .frame(height: 180)
            .cornerRadius(10)
    }
    
    private var editOrDeleteNewsComponent: some View {
        HStack {
            Button(action: {
                editNews(news)
            }) {
                HStack {
                    Text("Gestionar noticia")
                        .font(.body)
                        .foregroundStyle(Color.white)
                    
                    Image(systemName: "arrow.up.right")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .foregroundColor(.white)
                }
            }
            
            Spacer()
            
            Button(action: {
                deleteNew(news)
            }) {
                Text("Borrar Noticia")
                    .font(.body)
                    .foregroundStyle(Color.red)
                    .padding(.trailing, 2)
            }
        }
        .padding(.bottom, 40)
    }
}
