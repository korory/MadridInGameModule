//
//  DetailsExpandableView.swift
//  Pods
//
//  Created by Arnau Rivas Rivas on 31/3/25.
//

import SwiftUI

// TODO: Replace with Codable model and Directus integration when backend is ready
struct ExpandableDetailItemModel: Identifiable {
    let id = UUID()
    let icon: String        // SF Symbol name
    let title: String
    let description: String
    let color: Color
}

struct DetailsExpandableView: View {
    var title: String

    // TODO: Replace with `var items: [ExpandableDetailItemModel]` received from API/ViewModel
    private let items: [ExpandableDetailItemModel] = [
        ExpandableDetailItemModel(
            icon: "desktopcomputer",
            title: "Formato de torneos",
            description: "Cada torneo se juega en formato competitivo adaptado al juego.\nIncluye fases clasificatorias y eliminatorias según el número de participantes.",
            color: Color(red: 0.18, green: 0.35, blue: 0.85)
        ),
        ExpandableDetailItemModel(
            icon: "gamecontroller",
            title: "Sistema de puntos",
            description: "Los puntos se acumulan por cada partida jugada y se reflejan en la clasificación general.",
            color: Color(red: 0.75, green: 0.15, blue: 0.55)
        ),
        ExpandableDetailItemModel(
            icon: "trophy",
            title: "Splits y temporada",
            description: "La temporada está dividida en splits. Cada split tiene su propio ranking y premio final.",
            color: Color(red: 0.45, green: 0.15, blue: 0.75)
        ),
        ExpandableDetailItemModel(
            icon: "person.2",
            title: "Participación",
            description: "La liga está abierta a jugadores de todos los niveles.",
            color: Color(red: 0.15, green: 0.55, blue: 0.25)
        )
    ]

    @State private var expandedItemID: UUID? = nil

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color.black, Color.black, Color.white.opacity(0.15)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea(.all)

            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text(title.uppercased())
                        .font(.madridInGameiOSFont(size: 20))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 5)

                    if items.isEmpty {
                        Text("competitions.subheadings.notFound".localized)
                            .foregroundColor(.white)
                            .padding()
                    } else {
                        ForEach(items) { item in
                            ExpandableDetailCellView(
                                icon: item.icon,
                                title: item.title,
                                description: item.description,
                                color: item.color,
                                isExpanded: Binding(
                                    get: { expandedItemID == item.id },
                                    set: { isOpen in expandedItemID = isOpen ? item.id : nil }
                                )
                            )
                        }
                    }

                    Spacer()
                }
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .padding(.bottom)
            }
        }
    }
}
