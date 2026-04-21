//
//  DetailsTournamentView.swift
//  Pods
//
//  Created by Arnau Rivas Rivas on 11/2/25.
//

import SwiftUI

struct DetailsTournamentView: View {
    var title: String
    var content: [TournamentModel]?

    @State private var showNicknamePopup = false
    @State private var selectedURL: String = ""
    @State private var selectedTournamentId: Int? = nil
    @State private var nickname: String = ""
    @State private var isSubmitting = false

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.white.opacity(0.2), Color.white.opacity(0.4)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(.all)

            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text(title.uppercased())
                        .font(.madridInGameiOSFont(size: 20))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 5)

                    if let content, !content.isEmpty {
                        ForEach(content) { singleContent in
                            TournamentCellView(
                                date: singleContent.date ?? "",
                                name: singleContent.name ?? "",
                                targetURL: singleContent.link ?? "",
                                statusString: singleContent.status ?? ""
                            ) { url in
                                selectedURL = url
                                selectedTournamentId = singleContent.id
                                nickname = UserManager.shared.getUser()?.username ?? ""
                                showNicknamePopup = true
                            }
                        }
                    } else {
                        Text("competitions.subheadings.notFound".localized)
                            .foregroundColor(.white)
                            .padding()
                    }

                    Spacer()
                }
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .padding(.bottom)
            }

            CustomPopup(isPresented: $showNicknamePopup) {
                VStack(spacing: 16) {
                    Text("Antes de continuar…")
                        .font(.madridInGameiOSFont(size: 20))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)

                    Text("¿Con qué alias competirás en el torneo?")
                        .font(.madridInGameiOSFont(size: 15))
                        .foregroundColor(.white.opacity(0.75))
                        .multilineTextAlignment(.center)

                    TextField("", text: $nickname)
                        .font(.madridInGameiOSFont(size: 15))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(Color.white.opacity(0.06))
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.15), lineWidth: 1))
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)

                    Text("Lo usamos para rastrear tus stats automáticamente.")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.4))
                        .multilineTextAlignment(.center)

                    CustomButton(
                        text: "Continuar e Inscribirme",
                        needsBackground: true,
                        backgroundColor: .cyan,
                        pressEnabled: !isSubmitting,
                        widthButton: 280,
                        heightButton: 50
                    ) {
                        submitInscriptionAndOpen()
                    }
                    .padding(.top, 4)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
            }
            .zIndex(1)
        }
    }

    private func submitInscriptionAndOpen() {
        let user = UserManager.shared.getUser()
        var body: [String: Any] = [
            "alias": nickname,
            "status": "published"
        ]
        if let userId = user?.id { body["id_user"] = userId }
        if let tournamentId = selectedTournamentId { body["id_tournament"] = tournamentId }
        if let teamId = UserManager.shared.getSelectedTeam()?.id { body["id_team"] = teamId }
        if let email = user?.email { body["email"] = email }

        Logger.shared.log("[TournamentInscription] Sending POST to tournament_inscriptions")
        Logger.shared.log("[TournamentInscription] Body: \(body)")

        isSubmitting = true
        Task {
            do {
                _ = try await DirectusService.shared.request(
                    endpoint: "tournament_inscriptions",
                    method: .POST,
                    body: body
                )
                Logger.shared.log("[TournamentInscription] ✅ Inscription created successfully")
            } catch {
                Logger.shared.log("[TournamentInscription] ❌ Error: \(error.localizedDescription)")
            }
            await MainActor.run {
                isSubmitting = false
                showNicknamePopup = false
                let urlString = selectedURL.isEmpty ? "https://webesports.madridingame.es/esports-center/" : selectedURL
                Logger.shared.log("[TournamentInscription] Opening URL: \(urlString)")
                if let url = URL(string: urlString) {
                    UIApplication.shared.open(url)
                }
            }
        }
    }
}
