//
//  ColorLegendView.swift
//  Pods
//
//  Created by Arnau Rivas Rivas on 21/3/25.
//

import SwiftUI

struct ColorLegendView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Leyenda")
                .font(.custom("Madridingamefont-Regular", size: 20))
                .padding(.leading, 10)
                .padding(.bottom, 10)
            
            legendItem(color: .white, text: "Día actual")
            legendItem(color: .blue, text: "Reserva individual")
            legendItem(color: .blue.opacity(0.5), text: "Reserva de equipo")
            legendItem(color: .red, text: "Día bloqueado")
        }
        .padding(.bottom, 25)
    }

    private func legendItem(color: Color, text: String) -> some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 20, height: 20)
            Text(text)
                .font(.custom("Madridingamefont-Regular", size: 15))
            
            Spacer()
        }
        .padding(.leading, 40)
    }
}
