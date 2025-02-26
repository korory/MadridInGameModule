//
//  NewsFlowComponent.swift
//  Pods
//
//  Created by Arnau Rivas Rivas on 25/2/25.
//

import SwiftUI

struct NewsFlowComponent: View {
    @Environment(\.presentationMode) var presentationMode
    var news: NewsModel?
    
    var body: some View {
        ZStack(alignment: .top) {
            // Fondo negro
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.black, Color.black, Color.white.opacity(0.15)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(.all)
            
            VStack (alignment: .leading, spacing: 15){
                titleBanner
                    newsTitle
                ScrollView {
                    bodyNews
                    newsImage(170)
                }
            }
            .padding()
        }
    }
}

extension NewsFlowComponent {
    private var titleBanner: some View {
        HStack {
            Text("Noticias")
                .font(.custom("Madridingamefont-Regular", size: 25))
                .foregroundColor(.white)
                .padding(.leading, 5)
            
            Spacer()
            
            Button {
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "xmark.circle")
                    .resizable()
                    .frame(width: 28, height: 28)
                    .foregroundStyle(.white)
            }
            .padding()
            
        }
    }
    
    private var newsTitle: some View {
        VStack (alignment: .leading) {
            Text(news?.title ?? "No hay titulo")
                .font(.custom("Madridingamefont-Regular", size: 20))
                .foregroundColor(.white)
        }
        .padding(.leading, 10)
    }
    
    private var bodyNews: some View {
        HStack () {
            Text(news?.body ?? "No hay descripción de la noticia")
                .font(.body)
                .foregroundStyle(.white)
            
            Spacer()
        }
        .padding(.leading, 15)
    }
    
    private func newsImage(_ imageSize: CGFloat) -> some View {
        let newsImage = news?.image;
        
        let environmentManager = EnvironmentManager()
        
        return AnyView(
            AsyncImage(url: URL(string: "\(environmentManager.getBaseURL())/assets/\(newsImage ?? "")")) { phase in
                switch phase {
                case .empty:
                    VStack {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                            .scaleEffect(1.5)
                            .padding()
                        
                        Text("Cargando Imagen")
                            .font(.custom("Madridingamefont-Regular", size: 15))
                            .foregroundColor(.white)
                            .opacity(0.7)
                    }
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        //.frame(height: imageSize)
                        .clipShape(RoundedRectangle(cornerRadius: 10.0))
                        .padding()
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: imageSize, height: imageSize)
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
        )
    }
}
