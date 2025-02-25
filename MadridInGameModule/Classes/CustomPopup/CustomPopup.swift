//
//  CustomPopup.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 10/10/24.
//


import SwiftUI

struct CustomPopup<Content: View>: View {
    @Binding var isPresented: Bool
    @ViewBuilder let content: Content

    var body: some View {
        if isPresented {
            ZStack {
                // Fondo semitransparente con animación
                Color.black.opacity(0.7)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture { isPresented.toggle() }

                // Contenedor del popup
                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        Button(action: { isPresented.toggle() }) {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.black.opacity(0.7))
                                .padding(10)
                        }
                    }
                    
                    content
                        .padding()
                }
                .frame(maxWidth: 380)
                .background(.ultraThinMaterial) // Fondo translúcido moderno
                .cornerRadius(12)
                .shadow(radius: 5)
                .transition(.scale.combined(with: .opacity))
                .animation(.easeInOut, value: isPresented)
            }
        }
    }
}

//struct CustomPopup<Content: View>: View {
//    @Binding var isPresented: Bool
//    let content: () -> Content
//
//    var body: some View {
//        if isPresented {
//            ZStack {
//                // Fondo semitransparente
//                Color.black.opacity(0.5)
//                    .edgesIgnoringSafeArea(.all)
//                
//                // Contenedor del popup
//                VStack(spacing: 0) {
//                    HStack {
//                        Spacer()
//                        Button(action: {
//                            isPresented.toggle()
//                        }) {
//                            Image(systemName: "xmark")
//                                .foregroundColor(.black)
//                                .padding()
//                        }
//                    }
//                    
//                    content()
//                        .padding(.bottom, 7)
//                }
//                .background(Color.blue)
//                .cornerRadius(10)
//            }
//        }
//    }
//}

//struct CustomPopupPreview: View {
//    @State private var isPopupPresented = false
//    
//    var body: some View {
//        VStack {
//            Button("Mostrar Popup") {
//                isPopupPresented = true
//            }
//            .padding()
//            
//            CustomPopup(isPresented: $isPopupPresented) {
//                VStack {
//                    Text("Hola")
//                }
//            }
//        }
//    }
//}
//
//#Preview {
//    CustomPopupPreview()
//}
