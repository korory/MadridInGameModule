//
//  NewsCellComponentView.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 17/10/24.
//

import SwiftUI

struct NewsCellComponentView: View {
    @StateObject var viewModel: NewsCellViewModel
    var newsSelected: (NewsModel) -> Void
    
    var body: some View {
        HStack{
            VStack(alignment: .leading, spacing: 15) {
                newsContent
                newsImage(170)
            }
            
            Spacer()
            
            buttonArrow
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(15)
        .onTapGesture {
            newsSelected(viewModel.news)
        }
    }
}

extension NewsCellComponentView {
    
    private func newsImage(_ imageSize: CGFloat) -> some View {
        let newsImage = viewModel.news.image;
        
        let environmentManager = EnvironmentManager()
        
        return AnyView(
            AsyncImage(url: URL(string: "\(environmentManager.getBaseURL())/assets/\(newsImage ?? "")")) { phase in
                switch phase {
                case .empty:
                    VStack {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.purple))
                            .scaleEffect(1.5)
                            .padding()
                        
                        Text("Cargando Imagen")
                            .font(.madridInGameiOSFont(size: 15))
                            .foregroundColor(.white)
                            .opacity(0.7)
                    }
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: imageSize)
                        .clipShape(RoundedRectangle(cornerRadius: 10.0))
                        .padding()
                case .failure:
                    EmptyView()
                @unknown default:
                    EmptyView()
                }
            }
        )
    }
    
    private var newsContent: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.news.title ?? "")
                .font(.madridInGameiOSFont(size: 15))
                .foregroundColor(.white)
                .lineLimit(2)
                
            Text(viewModel.news.body ?? "")
                .font(.body)
                .foregroundColor(.gray)
                .lineLimit(7)
            
        }
    }
    
    private var buttonArrow: some View {
        Button(action: {
            newsSelected(viewModel.news)
        }) {
            Image(systemName: "chevron.right")
                .foregroundColor(.white)
        }
    }
}
