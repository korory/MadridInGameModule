//// The Swift Programming Language
//// https://docs.swift.org/swift-book

import SwiftUI

public struct MadridInGameModule: View {
    @StateObject private var viewModel: MadridInGameViewModel
    
    public init(email: String, isPro: Bool, logoMIG: UIImage, openCompetitions: Bool ) {
        UserDefaults.saveLogoMIG(logoMIG)

        _viewModel = StateObject(wrappedValue: MadridInGameViewModel(email: email, isPro: isPro, openCompetitions: openCompetitions))
    }
    
    public var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.black, Color.black, Color.black.opacity(0.9)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(.all)
            
            if viewModel.isLoading {
                LoadingView(message: "Preparando tu experiencia...")
            } else if let errorMessage = viewModel.errorMessage {
                errorView(errorMessage)
            } else if let user = viewModel.user {
                contentView(user: user)
            }
        }
        .onAppear {
            viewModel.initializeModule()
        }
    }
    
    private func errorView(_ message: String) -> some View {
        VStack {
            Text("Error al cargar el módulo")
                .foregroundColor(.red)
            Text(message)
                .foregroundColor(.white)
        }
        .padding()
    }
    
    private func contentView(user: UserModel) -> some View {
        VStack {
            topBarView
        }
    }
    
    private var topBarView: some View {
        VStack {
            HStack {
                tabButton(title: "Dashboard", tab: 0)
                if !viewModel.getUserTeams().isEmpty {
                    tabButton(title: "Equipos", tab: 1)
                }
                tabButton(title: "Competiciones", tab: 2)
            }
            .padding(.horizontal, 10)
            
            if viewModel.selectedTab == 0 {
                DashboardScreenView()
            } else if viewModel.selectedTab == 1 {
                TeamsScreenView()
            } else {
                NavigationView {
                    CompetitionsView(viewModel: CompetitionsViewModel())
                }
            }
        }
    }
    
    private func tabButton(title: String, tab: Int) -> some View {
        Button(action: { viewModel.selectTab(tab) }) {
            VStack {
                Text(title)
                    .foregroundColor(viewModel.selectedTab == tab ? .cyan : .white)
                    .frame(maxWidth: .infinity)
                Rectangle()
                    .fill(viewModel.selectedTab == tab ? Color.cyan : Color.clear)
                    .frame(height: 3)
            }
        }
    }
}


/*struct MadridInGameModule_Previews: PreviewProvider {
    static var previews: some View {
        MadridInGameModule()
    }
}


#Preview {
    MadridInGameModule()
}
*/
