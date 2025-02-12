//
//  TextWithUnderlineComponent.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 16/10/24.
//


import SwiftUI

struct TextWithUnderlineComponent: View {
    let title: String
    let underlineColor: Color
    
    var body: some View {
        VStack {
            Text(title)
                .font(.custom("Madridingamefont-Regular", size: 17))

                //.font(.body)
                .foregroundColor(.white)
                .background(
                    GeometryReader { geometry in
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: geometry.size.width, height: 5)
                            .foregroundColor(underlineColor)
                            .offset(y: 15)
                    }
                    .frame(height: 0)
                )
        }
    }
}

#Preview {
    TextWithUnderlineComponent(title: "Jugadores", underlineColor: Color.cyan)
        .padding()
        .background(Color.black)
}
