//
//  DetailsExpandableView.swift
//  Pods
//
//  Created by Arnau Rivas Rivas on 31/3/25.
//

import SwiftUI

// TODO: Replace with Codable model and Directus integration when backend is ready
struct ExpandableDetailItemModel: Identifiable {
    let id: String          // stable key, e.g. CMS key
    let icon: String        // SF Symbol name
    let title: String
    let description: String
    let color: Color
}

struct DetailsExpandableView: View {
    var title: String

    private var items: [ExpandableDetailItemModel] {[
        ExpandableDetailItemModel(
            id: "tournamentFormat",
            icon: "desktopcomputer",
            title: "competitions.details.cards.tournamentFormat.title".localized,
            description: "competitions.details.cards.tournamentFormat.description".localized,
            color: Color(red: 0.18, green: 0.35, blue: 0.85)
        ),
        ExpandableDetailItemModel(
            id: "pointsSystem",
            icon: "gamecontroller",
            title: "competitions.details.cards.pointsSystem.title".localized,
            description: "competitions.details.cards.pointsSystem.description".localized,
            color: Color(red: 0.75, green: 0.15, blue: 0.55)
        ),
        ExpandableDetailItemModel(
            id: "splitsAndSeason",
            icon: "trophy",
            title: "competitions.details.cards.splitsAndSeason.title".localized,
            description: "competitions.details.cards.splitsAndSeason.description".localized,
            color: Color(red: 0.45, green: 0.15, blue: 0.75)
        ),
        ExpandableDetailItemModel(
            id: "participation",
            icon: "person.2",
            title: "competitions.details.cards.participation.title".localized,
            description: "competitions.details.cards.participation.description".localized,
            color: Color(red: 0.15, green: 0.55, blue: 0.25)
        )
    ]}

    @State private var expandedItemID: String? = nil

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
