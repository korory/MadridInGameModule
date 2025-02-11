//
//  LoadingView.swift
//  Pods
//
//  Created by Arnau Rivas Rivas on 7/2/25.
//

import SwiftUI

struct LoadingView: View {
    var logoMIG: UIImage

    var body: some View {
        ZStack {
            // Fondo con un gradiente sutil para dar más profundidad
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.gray.opacity(0.3)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                // Animación del logo
                Image(uiImage: logoMIG)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 50)
                
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.purple)) // Color de progreso
                    .scaleEffect(1.5) // Tamaño del indicador

                // Un subtitulo o mensaje opcional
                Text("Preparando tu experiencia...") // Mensaje adicional
                    .font(.headline)
                    .foregroundColor(.white)
                    .opacity(0.7)
            }
            .padding(.horizontal, 20)
        }
    }
}


//struct LoadingView: View {
//    var logoMIG: UIImage
//    
//    var body: some View {
//        VStack(spacing: 2) {
//            Image(uiImage: logoMIG)
//                .resizable()
//                .scaledToFit()
//                .frame(width: 100, height: 80)
//            ProgressView()
//                .progressViewStyle(CircularProgressViewStyle(tint: .white))
//        }
//        .background(Color.black)
//    }
//    
//}
