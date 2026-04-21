//
//  CompetitionsDetailViewComponentView.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 17/10/24.
//

import SwiftUI

enum Tab {
    case overview
    case teams
    case schedule
    case results
    case tournaments
}

struct CompetitionsDetailViewComponentView: View {
    @ObservedObject var viewModel: CompetitionsDetailViewModel
    @Environment(\.dismiss) private var dismiss
    private let environmentManager = EnvironmentManager()

    private var safeAreaTop: CGFloat {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows.first?.safeAreaInsets.top ?? 47
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                bannerHeader

                if let splits = viewModel.competitionsInformation.splits, !splits.isEmpty {
                    splitsChipRow(splits: splits)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                }

                if viewModel.competitionsInformation.splits?.isEmpty == false {
                    if viewModel.optionTabSelected != nil {
                        tabBarComponent
                    } else {
                        ProgressView().tint(.white).padding()
                        Spacer()
                    }
                } else {
                    Text("competitions.subheadings.notFound".localized)
                        .foregroundColor(.white)
                        .padding()
                    Spacer()
                }
            }

            // Title bar always on top, outside banner/GeometryReader
            bannerTitleBar
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .ignoresSafeArea(edges: .top)
        .onAppear {
            viewModel.getFirstOptionSelected()
        }
    }

    private var bannerTitleBar: some View {
        VStack {
            Spacer()
            ZStack {
                // Title centered
                if let title = viewModel.competitionsInformation.title {
                    Text(title)
                        .font(.madridInGameiOSFont(size: 22))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.9), radius: 4)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .padding(.horizontal, 56)
                }

                // Back button pinned to leading edge
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 16)
                            .foregroundStyle(.white)
                            .frame(width: 44, height: 44)
                            .contentShape(Rectangle())
                    }
                    Spacer()
                }
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 16)
        }
        .frame(height: safeAreaTop + 140)
    }

    // MARK: - Banner header

    private var bannerHeader: some View {
        let bannerPath = viewModel.optionTabSelected?.banner ?? viewModel.competitionsInformation.game?.banner ?? ""
        let bannerURL = URL(string: "\(environmentManager.getBaseURL())/assets/\(bannerPath)")
        let totalHeight: CGFloat = safeAreaTop + 140

        return GeometryReader { geo in
            ZStack {
                // Background fallback
                Color.gray.opacity(0.2)

                // Banner image
                if let url = bannerURL, !bannerPath.isEmpty {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: geo.size.width, height: totalHeight)
                                .clipped()
                        default:
                            EmptyView()
                        }
                    }
                }

                // Gradient: transparent at top → black at bottom
                LinearGradient(
                    colors: [.clear, .clear, Color.black.opacity(0.7), .black],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(width: geo.size.width, height: totalHeight)


            }
            .frame(width: geo.size.width, height: totalHeight)
            .clipped()
        }
        .frame(height: totalHeight)
    }

    // MARK: - Splits chips

    @ViewBuilder
    private func splitsChipRow(splits: [SplitModel]) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(splits) { split in
                    let isSelected = viewModel.optionTabSelected?.id == split.id
                    Button {
                        viewModel.optionTabSelected = split
                    } label: {
                        Text((split.name ?? "").uppercased())
                            .font(.system(size: 13, weight: isSelected ? .semibold : .regular))
                            .foregroundColor(isSelected ? .black : .white)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(isSelected ? Color.cyan : Color.white.opacity(0.12))
                            .cornerRadius(20)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .animation(.easeInOut(duration: 0.15), value: viewModel.optionTabSelected?.id)
                }
            }
        }
    }

    // MARK: - Tab bar

    private var tabBarComponent: some View {
        let split = viewModel.optionTabSelected
        let competition = viewModel.competitionsInformation

        return TabView(selection: $viewModel.selectedTab) {
            DetailSectionView(
                title: "competitions.about".localized,
                content: split?.overview ?? competition.overview
            )
            .tabItem { Label("competitions.overview".localized, systemImage: "info.circle") }
            .tag(Tab.overview)

            DetailsExpandableView(title: "competitions.details".localized)
                .tabItem { Label("competitions.details".localized, systemImage: "person.2") }
                .tag(Tab.teams)

            DetailsRulesView(
                title: "competitions.rules".localized,
                rulesText: split?.rules ?? competition.rules,
                pdfFile: competition.pdfFile
            )
            .tabItem { Label("competitions.rules".localized, systemImage: "clock") }
            .tag(Tab.schedule)

            DetailsContactView(
                sectionTitle: "competitions.contact".localized,
                contact: split?.contact ?? competition.contact
            )
            .tabItem { Label("competitions.contact".localized, systemImage: "envelope.fill") }
            .tag(Tab.results)

            DetailsTournamentView(
                title: "competitions.tournaments".localized,
                content: split?.tournaments
            )
            .tabItem { Label("competitions.tournaments".localized, systemImage: "trophy.fill") }
            .tag(Tab.tournaments)
        }
        .accentColor(.cyan)
    }
}
