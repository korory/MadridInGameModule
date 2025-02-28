import SwiftUI

struct PlayersTeamComponentView: View {
    @StateObject var viewModel = PlayersTeamComponentViewModel()

    @State private var playerSelectedToRemove: PlayerModel?
    @State private var isRemoveCellPressed: Bool = false

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.black, Color.black, Color.white.opacity(0.15)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(.all)
            
                VStack(alignment: .leading, spacing: 20) {
                    titleBanner
                    listOfAllPlayersComponent
                }
                .padding()
        }
    }
}

extension PlayersTeamComponentView {
    private var titleBanner: some View {
        Text("JUGADORES")
            .font(.custom("Madridingamefont-Regular", size: 25))
            .foregroundStyle(Color.white)
    }

    private var listOfAllPlayersComponent: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.getAllPlayersWithTeamSelected()) { player in
                    PlayerTeamComponentCell(playerInformation: player)
                    .padding(.top, 10)
                }
            }
        }
    }
}
