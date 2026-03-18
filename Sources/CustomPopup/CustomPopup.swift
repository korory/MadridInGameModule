//
//  CustomPopup.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 10/10/24.
//

import SwiftUI

struct CustomPopup<Content: View>: View {
    @Binding var isPresented: Bool
    var onDismiss: (() -> Void)?
    @ViewBuilder let content: Content

    @State private var animateIn: Bool = false

    var body: some View {
        if isPresented {
            ZStack {
                // Fondo oscuro
                Color.black.opacity(animateIn ? 0.75 : 0)
                    .ignoresSafeArea(.all)
                    .onTapGesture { dismiss() }

                VStack(spacing: 0) {
                    // Botón cerrar
                    HStack {
                        Spacer()
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white.opacity(0.5))
                                .frame(width: 32, height: 32)
                                .background(Color.white.opacity(0.1))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 4)

                    content
                        .padding(.horizontal, 4)
                        .padding(.bottom, 20)
                }
                .frame(maxWidth: 360)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color(white: 0.11))
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color.white.opacity(0.08), lineWidth: 1)
                        )
                )
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .shadow(color: .black.opacity(0.5), radius: 30, x: 0, y: 10)
                .scaleEffect(animateIn ? 1 : 0.9)
                .opacity(animateIn ? 1 : 0)
                .padding(.horizontal, 24)
            }
            .onAppear {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                    animateIn = true
                }
            }
        }
    }

    private func dismiss() {
        withAnimation(.easeOut(duration: 0.2)) {
            animateIn = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            isPresented = false
            onDismiss?()
        }
    }
}
