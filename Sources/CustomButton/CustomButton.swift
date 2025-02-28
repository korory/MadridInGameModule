//
//  CustomButton.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 10/10/24.
//


import SwiftUI

struct CustomButton: View {
    let text: String
    let needsBackground: Bool?
    let backgroundColor: Color?
    let pressEnabled: Bool
    let widthButton: CGFloat?
    let heightButton: CGFloat?
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            if pressEnabled {
                action()
            }
        }) {
            Text(text)
                .font(.custom("Madridingamefont-Regular", size: 17))
                .foregroundStyle(needsBackground ?? false ? .black : .white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(needsBackground ?? false ? (backgroundColor ?? Color.white) : Color.clear)
                .cornerRadius(40)
                .overlay(
                    RoundedRectangle(cornerRadius: 40)
                        .stroke(needsBackground ?? false ? (backgroundColor ?? Color.white) : Color.white, lineWidth: 2)
                )
        }
        .disabled(!pressEnabled)
        .frame(width: widthButton ?? 180 , height: heightButton ?? 50)
    }
}

#Preview {
    CustomButton(text: "Press Me", needsBackground: true, backgroundColor: Color.gray, pressEnabled: true, widthButton: 180 , heightButton: 50, action: {
        print("Button pressed!")
    })
}
