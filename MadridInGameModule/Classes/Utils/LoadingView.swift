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
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.gray.opacity(0.3)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Image(uiImage: logoMIG)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 50)
                
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.purple))
                    .scaleEffect(1.5)

                Text("Preparando tu experiencia...")
                    .font(.headline)
                    .foregroundColor(.white)
                    .opacity(0.7)
            }
            .padding(.horizontal, 20)
        }
    }
}
