//
//  ColorLegendView.swift
//  Pods
//
//  Created by Arnau Rivas Rivas on 21/3/25.
//

import SwiftUI

struct ColorLegendView: View {
    private let items: [(color: Color, text: String)] = [
        (.white, "Día actual".localized),
        (.blue, "Reserva individual".localized),
        (.blue.opacity(0.5), "Reserva de equipo".localized),
        (.red, "Día bloqueado".localized)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("legend".localized)
                .font(.madridInGameiOSFont(size: 20))
                .foregroundColor(.white)
                .padding(.bottom, 20)
                .frame(maxWidth: .infinity, alignment: .center)

            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                legendItem(color: item.color, text: item.text)

                if index < items.count - 1 {
                    Divider()
                        .background(Color.white.opacity(0.08))
                        .padding(.horizontal, 4)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
    }

    private func legendItem(color: Color, text: String) -> some View {
        HStack(spacing: 14) {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
                .shadow(color: color.opacity(0.5), radius: 4, x: 0, y: 0)

            Text(text)
                .font(.madridInGameiOSFont(size: 15))
                .foregroundColor(.white.opacity(0.8))

            Spacer()
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 4)
    }
}
