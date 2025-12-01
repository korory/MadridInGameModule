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
            Text("legend".localized)
                .font(.madridInGameiOSFont(size: 20))
                .padding(.leading, 10)
                .padding(.bottom, 10)
            
            legendItem(color: .white, text: "Día actual".localized)
            legendItem(color: .blue, text: "Reserva individual".localized)
            legendItem(color: .blue.opacity(0.5), text: "Reserva de equipo".localized)
            legendItem(color: .red, text: "Día bloqueado".localized)
        }
        .padding(.bottom, 25)
    }

    private func legendItem(color: Color, text: String) -> some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 20, height: 20)
            Text(text)
                .font(.madridInGameiOSFont(size: 15))
            
            Spacer()
        }
        .padding(.leading, 40)
    }
}
