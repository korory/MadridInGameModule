//
//  ToastMessage.swift
//  Pods
//
//  Created by Arnau Rivas Rivas on 21/2/25.
//


import SwiftUI

struct ToastMessage: View {
    let message: String
    let duration: TimeInterval
    let success: Bool
    let onDismiss: () -> Void
    
    @State private var isVisible = false

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Image(systemName: success ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundStyle( success ? .green : .red)
                    .padding(.trailing, 10)
                Text(message)
                    .font(.custom("Madridingamefont-Regular", size: 20))
                    .foregroundColor(.white)
                    .padding()
                Spacer()
            }
            .background(Color.black.opacity(0.8))
            .cornerRadius(10)
            .shadow(radius: 5)
            .opacity(isVisible ? 1 : 0)
            .padding(.bottom, 50)
            .frame(width: UIScreen.main.bounds.width / 1)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.5)) {
                isVisible = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isVisible = false
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    onDismiss()
                }
            }
        }
    }
}
