//
//  CompetitionsCarouselComponentView.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 17/10/24.
//

import SwiftUI

struct CompetitionsCarouselComponentView: View {
    let leagueInformation: LeagueModel
    let environmentManager = EnvironmentManager()
    @State private var isDescriptionExpanded = false

    var body: some View {
        ZStack {
            Color.clear
                .ignoresSafeArea(.all)

            VStack (alignment: .leading, spacing: 20){
                titleBanner
                if !leagueInformation.description.isEmpty {
                    subtitleBanner
                }
                carrouselComponent
                Spacer()
            }
        }
    }
}

extension CompetitionsCarouselComponentView {
    private var titleBanner: some View {
        VStack (alignment: .leading, spacing: 12){
            Text(leagueInformation.title)
                .font(.madridInGameiOSFont(size: 24))
                .font(.system(size: 25).weight(.bold))
                .foregroundStyle(Color.white)
            
            Text(leagueInformation.seriesTitle)
                .font(.system(size: 17).weight(.bold))
                .foregroundStyle(Color.gray)
        }
    }
    
    private var subtitleBanner: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(leagueInformation.description)
                .font(.system(size: 12))
                .foregroundStyle(Color.white.opacity(0.75))
                .lineLimit(isDescriptionExpanded ? nil : 2)
                .animation(.easeInOut(duration: 0.2), value: isDescriptionExpanded)

            Button {
                isDescriptionExpanded.toggle()
            } label: {
                HStack(spacing: 4) {
                    Text(isDescriptionExpanded ? "dashboard.profile.seeLess".localized : "dashboard.profile.seeMore".localized)
                        .font(.system(size: 13, weight: .semibold))
                    Image(systemName: isDescriptionExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 11, weight: .semibold))
                }
                .foregroundColor(.cyan)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(Color.cyan.opacity(0.12))
                .cornerRadius(20)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    private var carrouselComponent: some View {
        let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]
        return LazyVGrid(columns: columns, spacing: 12) {
            ForEach(leagueInformation.allCompetitions) { competitionInformation in
                NavigationLink {
                    CompetitionsDetailViewComponentView(viewModel: CompetitionsDetailViewModel(competitionsInformation: competitionInformation))
                } label: {
                    CompetitionCardView(competition: competitionInformation, environmentManager: environmentManager)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

// MARK: - Competition Card

private struct CompetitionCardView: View {
    let competition: CompetitionData
    let environmentManager: EnvironmentManager

    private static let imageMinHeight: CGFloat = 110
    private static let imageMaxHeight: CGFloat = 320
    private static let infoHeight: CGFloat = 130

    private var modalityLabel: String {
        switch competition.game?.type {
        case "in-person": return "competition.modality.hybrid".localized
        case "online":    return "competition.modality.online".localized
        default:          return ""
        }
    }

    private var modalityColor: Color {
        competition.game?.type == "in-person" ? .cyan : .green
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            gameImage
            cardInfo
        }
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(0.07))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.12), lineWidth: 1)
        )
    }

    @ViewBuilder
    private var gameImage: some View {
        if let imageId = competition.image ?? competition.game?.image {
            AsyncImage(url: URL(string: "\(environmentManager.getBaseURL())/assets/\(imageId)")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(maxWidth: .infinity, minHeight: Self.imageMinHeight, maxHeight: Self.imageMaxHeight)
                        .tint(.purple)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, minHeight: Self.imageMinHeight, maxHeight: Self.imageMaxHeight)
                case .failure:
                    placeholderImage
                @unknown default:
                    EmptyView()
                }
            }
            .cornerRadius(16, corners: [.topLeft, .topRight])
        } else {
            placeholderImage
        }
    }

    private var placeholderImage: some View {
        Image(systemName: "photo")
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity, minHeight: Self.imageMinHeight, maxHeight: Self.imageMaxHeight)
            .foregroundColor(.gray)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(16, corners: [.topLeft, .topRight])
    }

    private var cardInfo: some View {
        VStack(alignment: .leading, spacing: 6) {
            if let title = competition.title {
                Text(title.uppercased())
                    .font(.madridInGameiOSFont(size: 16))
                    .foregroundColor(.white)
                    .lineLimit(2)
            }

            if let html = competition.game?.description, !html.isEmpty,
               let attributed = html.htmlToAttributedString(color: .gray, size: 9) {
                Text(attributed)
                    .lineLimit(4)
                    .multilineTextAlignment(.leading)
            }

            Spacer(minLength: 0)

            if !modalityLabel.isEmpty {
                Text(modalityLabel)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(modalityColor)
                    .padding(.horizontal, 7)
                    .padding(.vertical, 3)
                    .background(modalityColor.opacity(0.15))
                    .cornerRadius(6)
            }
        }
        .padding(12)
        .frame(height: Self.infoHeight, alignment: .top)
    }
}

// MARK: - HTML rendering helper

private extension String {
    func htmlToAttributedString(color: UIColor, size: CGFloat) -> AttributedString? {
        let html = "<span style=\"font-family: -apple-system; font-size: \(size)pt; color: \(color.hexString);\">\(self)</span>"
        guard let data = html.data(using: .utf8),
              let nsAttr = try? NSAttributedString(
                data: data,
                options: [.documentType: NSAttributedString.DocumentType.html,
                          .characterEncoding: String.Encoding.utf8.rawValue],
                documentAttributes: nil)
        else { return nil }
        return try? AttributedString(nsAttr, including: \.uiKit)
    }
}

private extension UIColor {
    var hexString: String {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
    }
}

// MARK: - Corner radius helper

private extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

private struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

