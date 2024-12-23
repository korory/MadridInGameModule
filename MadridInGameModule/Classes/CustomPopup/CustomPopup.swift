//
//  CustomPopup.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 10/10/24.
//


import SwiftUI

struct CustomPopup<Content: View>: View {
    @Binding var isPresented: Bool
    let content: () -> Content

    var body: some View {
        if isPresented {
            ZStack {
                // Fondo semitransparente
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                
                // Contenedor del popup
                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        Button(action: {
                            isPresented.toggle()
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.black)
                                .padding()
                        }
                    }
                    
                    content()
                        .padding()
                }
                .background(Color.blue)
                .cornerRadius(10)
                .padding(20)
                .shadow(radius: 10)
            }
        }
    }
}

struct CustomPopupPreview: View {
    @State private var isPopupPresented = false
    
    var body: some View {
        VStack {
            Button("Mostrar Popup") {
                isPopupPresented = true
            }
            .padding()
            
            CustomPopup(isPresented: $isPopupPresented) {
                VStack {
                    Text("Hola")
                }
            }
        }
    }
}

#Preview {
    CustomPopupPreview()
}
