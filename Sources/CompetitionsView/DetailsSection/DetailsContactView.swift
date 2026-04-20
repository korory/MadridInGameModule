//
//  DetailsContactView.swift
//  Pods
//
//  Created by Arnau Rivas Rivas on 31/3/25.
//

import SwiftUI

struct DetailsContactView: View {
    var sectionTitle: String
    var contact: String?
    var cardTitle: String = "¿QUIERES SABER MÁS?"
    var email: String = "info@madridingame.es"
    var address: String = "Casa de Campo. Avenida Principal.\n3.28011. Madrid"

    // Extracts first email found in the contact text
    private var extractedEmail: String? {
        guard let text = contact?.decoded else { return nil }
        let pattern = "[A-Z0-9a-z._%+\\-]+@[A-Za-z0-9.\\-]+\\.[A-Za-z]{2,}"
        guard let regex = try? NSRegularExpression(pattern: pattern),
              let match = regex.firstMatch(in: text, range: NSRange(text.startIndex..., in: text)),
              let range = Range(match.range, in: text) else { return nil }
        return String(text[range])
    }

    // Extracts first Discord URL found in the contact text.
    // Searches raw HTML href attributes first (URL survives NSAttributedString decoding),
    // then falls back to standalone https URLs in the decoded plain text.
    private var discordURL: URL? {
        guard let raw = contact else { return nil }

        let hrefPattern = #"href=[\"']([^\"']*discord[^\"']*)[\"']"#
        if let regex = try? NSRegularExpression(pattern: hrefPattern, options: .caseInsensitive),
           let match = regex.firstMatch(in: raw, range: NSRange(raw.startIndex..., in: raw)),
           let range = Range(match.range(at: 1), in: raw),
           let url = URL(string: String(raw[range])),
           let scheme = url.scheme?.lowercased(),
           scheme == "https" || scheme == "http" {
            return url
        }

        let words = raw.decoded.components(separatedBy: .whitespacesAndNewlines)
        return words
            .compactMap { URL(string: $0) }
            .first {
                let scheme = $0.scheme?.lowercased()
                return $0.absoluteString.lowercased().contains("discord") &&
                       (scheme == "https" || scheme == "http")
            }
    }

    // Text before the email
    private var textBeforeEmail: String {
        guard let raw = contact?.decoded, let mail = extractedEmail else { return contact?.decoded ?? "" }
        let parts = raw.components(separatedBy: mail)
        return parts.first?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }

    // Text after the email, with Discord URL removed
    private var textAfterEmail: String {
        guard let raw = contact?.decoded, let mail = extractedEmail else { return "" }
        let parts = raw.components(separatedBy: mail)
        var after = parts.dropFirst().joined(separator: mail)
        if let discord = discordURL {
            after = after.replacingOccurrences(of: discord.absoluteString, with: "")
        }
        return after.trimmingCharacters(in: .whitespacesAndNewlines)
    }

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
                    Text(sectionTitle.uppercased())
                        .font(.madridInGameiOSFont(size: 20))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 5)

                    contactCard
                        .padding(.top, 8)

                    Spacer()
                }
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .padding(.bottom)
            }
        }
    }

    private var contactCard: some View {
        VStack(spacing: 16) {
            // Title
            Text(cardTitle)
                .font(.madridInGameiOSFont(size: 22))
                .fontWeight(.heavy)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)

            // Text before email (or fallback address)
            let before = textBeforeEmail.isEmpty ? address : textBeforeEmail
            Text(before)
                .font(.body)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)

            // Email button
            let displayEmail = extractedEmail ?? email
            Button {
                if let url = URL(string: "mailto:\(displayEmail)") {
                    UIApplication.shared.open(url)
                }
            } label: {
                Text(displayEmail)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.18))
                    .padding(.horizontal, 28)
                    .padding(.vertical, 12)
                    .background(Color(red: 0.62, green: 0.91, blue: 0.88))
                    .clipShape(Capsule())
            }

            // Text after email (Discord text without URL)
            if !textAfterEmail.isEmpty {
                Text(textAfterEmail)
                    .font(.body)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }

            // Discord button
            if let discordURL {
                Button {
                    UIApplication.shared.open(discordURL)
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "ellipsis.bubble.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                        Text("Únete a Discord")
                            .font(.body)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color(red: 0.35, green: 0.40, blue: 0.85))
                    .clipShape(Capsule())
                }
            }

            // Address — always shown at the bottom
            Text(address)
                .font(.body)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 44)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.42, green: 0.05, blue: 0.68), Color(red: 0.83, green: 0.0, blue: 0.78)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(12)
    }
}
