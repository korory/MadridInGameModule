////
////  CardDetailView.swift
////  CalendarComponent
////
////  Created by Arnau Rivas Rivas on 17/10/24.
////
//
//import SwiftUI
//
//struct CardDetailNewsView: View {
//    let news: NewsModel
//    
//    var body: some View {
//        ZStack {
//            LinearGradient(gradient: Gradient(colors: [Color.black, Color.black, Color.black, Color.white.opacity(0.15)]), startPoint: .top, endPoint: .bottom)
//                .ignoresSafeArea(.all)
//            
//            VStack (alignment: .leading, spacing: 20){
//                titleBanner
//                newsImageWithGradient
//                descriptionTextComponent
//            }
//            .padding()
//        }
//    }
//}
//
//extension CardDetailNewsView {
//    private var titleBanner: some View {
//        Text("NOTICIAS")
//            .font(.largeTitle)
//            .foregroundStyle(Color.white)
//    }
//    
//    private var newsImageWithGradient: some View {
//            ZStack(alignment: .bottom) {
////                Image(uiImage: news.image) // Reemplaza con el nombre de la imagen que deseas usar
////                    .resizable()
//                    //.scaledToFit()
//                LinearGradient(
//                    gradient: Gradient(colors: [.clear, .black.opacity(0.4)]),
//                    startPoint: .top,
//                    endPoint: .bottom
//                )
//                VStack {
//                    Spacer()
//                    newsTitleBanner
//                }
//                .frame(height: 50) // Ajusta la altura del degradado si es necesario
//            }
//            .frame(height: 280) // Ajusta la altura de la imagen si lo deseas
//            .cornerRadius(10)
//        }
//    
//    private var newsTitleBanner: some View {
//        Text(news.title ?? "")
//            .font(.title)
//            .foregroundStyle(Color.white)
//            .padding()
//    }
//    
//    private var descriptionTextComponent: some View {
//        ScrollView {
//            Text(news.body ?? "")
//                .font(.body)
//                .foregroundStyle(Color.white)
//                .padding()
//        }
//    }
//}
