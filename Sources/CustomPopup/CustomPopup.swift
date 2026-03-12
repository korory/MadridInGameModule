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

    var body: some View {
        if isPresented {
            ZStack {
                Color.black.opacity(0.7)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture { dismiss() }

                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.gray.opacity(0.4))
                                .padding(10)
                        }
                    }

                    content
                        .padding()
                }
                .frame(maxWidth: 380)
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                .shadow(radius: 5)
                .transition(.scale.combined(with: .opacity))
                .animation(.easeInOut, value: isPresented)
            }
        }
    }

    private func dismiss() {
        isPresented = false
        onDismiss?()
    }
}
