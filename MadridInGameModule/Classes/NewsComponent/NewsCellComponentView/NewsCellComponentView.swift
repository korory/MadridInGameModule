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
                        .frame(height: imageSize)
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
    
    private var newsContent: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.news.title ?? "")
                .font(.custom("Madridingamefont-Regular", size: 15))
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

//struct NewsCellComponentView: View {
//    @StateObject var viewModel: NewsCellViewModel
//    var newsSelected: (NewsModel) -> Void
//
//    var body: some View {
//        
//        VStack (alignment: .leading, spacing: 15) {
//            titleBanner
//            subtitleBanner
//        }
//        .background(Color.gray)
//        .cornerRadius(20)
//        .onTapGesture {
//            newsSelected(self.viewModel.news)
//        }
//    }
//}
//
//extension NewsCellComponentView {
//    private var titleBanner: some View {
//        Text(viewModel.news.title ?? "")
//            .font(.custom("Madridingamefont-Regular", size: 25))
//            .foregroundStyle(Color.white)
//            .padding()
//    }
//    
//    private var subtitleBanner: some View {
//        ScrollView {
//            Text(viewModel.news.body ?? "")
//                .font(.body)
//                .foregroundStyle(Color.white)
//                .lineLimit(nil)
//        }
//        .padding(.leading, 15)
//        .padding(.bottom, 10)
//        .padding(.trailing, 10)
//        .frame(maxHeight: 120)
//    }
//    
////    private var imageBanner: some View {
////        Image(uiImage: news.image)
////            .resizable()
////            .frame(height: 180)
////            .cornerRadius(10)
////    }
//    
////    private var editOrDeleteNewsComponent: some View {
////        HStack {
////            Button(action: {
////                editNews(news)
////            }) {
////                HStack {
////                    Text("Gestionar noticia")
////                        .font(.body)
////                        .foregroundStyle(Color.white)
////
////                    Image(systemName: "arrow.up.right")
////                        .resizable()
////                        .frame(width: 15, height: 15)
////                        .foregroundColor(.white)
////                }
////            }
////
////            Spacer()
////
////            Button(action: {
////                deleteNew(news)
////            }) {
////                Text("Borrar Noticia")
////                    .font(.body)
////                    .foregroundStyle(Color.red)
////                    .padding(.trailing, 2)
////            }
////        }
////        .padding(.bottom, 40)
////    }
//}

//struct NewsCellComponentView: View {
//    @StateObject var viewModel: NewsCellViewModel
//    var newsSelected: (NewsModel) -> Void
//
//    var body: some View {
//        
//        VStack (alignment: .leading, spacing: 15) {
//            titleBanner
//            subtitleBanner
//        }
//        .background(Color.gray)
//        .cornerRadius(20)
//        .onTapGesture {
//            newsSelected(self.viewModel.news)
//        }
//    }
//}
//
//extension NewsCellComponentView {
//    private var titleBanner: some View {
//        Text(viewModel.news.title ?? "")
//            .font(.custom("Madridingamefont-Regular", size: 25))
//            .foregroundStyle(Color.white)
//            .padding()
//    }
//    
//    private var subtitleBanner: some View {
//        ScrollView {
//            Text(viewModel.news.body ?? "")
//                .font(.body)
//                .foregroundStyle(Color.white)
//                .lineLimit(nil)
//        }
//        .padding(.leading, 15)
//        .padding(.bottom, 10)
//        .padding(.trailing, 10)
//        .frame(maxHeight: 120)
//    }
//    
////    private var imageBanner: some View {
////        Image(uiImage: news.image)
////            .resizable()
////            .frame(height: 180)
////            .cornerRadius(10)
////    }
//    
////    private var editOrDeleteNewsComponent: some View {
////        HStack {
////            Button(action: {
////                editNews(news)
////            }) {
////                HStack {
////                    Text("Gestionar noticia")
////                        .font(.body)
////                        .foregroundStyle(Color.white)
////                    
////                    Image(systemName: "arrow.up.right")
////                        .resizable()
////                        .frame(width: 15, height: 15)
////                        .foregroundColor(.white)
////                }
////            }
////            
////            Spacer()
////            
////            Button(action: {
////                deleteNew(news)
////            }) {
////                Text("Borrar Noticia")
////                    .font(.body)
////                    .foregroundStyle(Color.red)
////                    .padding(.trailing, 2)
////            }
////        }
////        .padding(.bottom, 40)
////    }
//}
