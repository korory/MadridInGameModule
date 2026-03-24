import SwiftUI

struct SelectTeamComponent: View {
    var allTeams: [TeamModelReal]
    var onTeamSelected: (TeamModelReal) -> Void

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea(.all)

            VStack(spacing: 0) {
                Spacer()

                Text("¿Qué equipo quieres gestionar?".localized)
                    .font(.madridInGameiOSFont(size: 20))
                    .bold()
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                    .padding(.bottom, 24)
                    .padding(.top, 20)

                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(allTeams, id: \.id) { team in
                            SelectTeamsCellComponent(team: team) { teamSelected in
                                onTeamSelected(teamSelected)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .scrollIndicators(.hidden)

                Spacer()
            }
        }
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
