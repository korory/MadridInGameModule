//// The Swift Programming Language
//// https://docs.swift.org/swift-book
//
import SwiftUI

public struct MadridInGameModule: View {
    @State private var selectedTab = 0
    @State private var isLoading = true
    @State private var user: User?
    @State private var errorMessage: String?
    
    private let email: String
    private let userManager = UserManager.shared
    
    public init(email: String) {
        self.email = email
    }
    
    public var body: some View {
            ZStack {
                Color.black
                    .ignoresSafeArea(edges: .all)

                if isLoading {
                    ProgressView("Cargando datos...")
                        .foregroundColor(.white)
                } else if let errorMessage = errorMessage {
                    VStack {
                        Text("Error al cargar el módulo")
                            .foregroundColor(.red)
                        Text(errorMessage)
                            .foregroundColor(.white)
                    }
                    .padding()
                } else if let user = user {
                    contentView(user: user)
                }
            }
            .onAppear {
                initializeModule()
            }
        }
}

extension MadridInGameModule {
    private func initializeModule() {
            userManager.initializeUser(withEmail: email) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self.user = userManager.getUser()
                        self.isLoading = false
                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                        self.isLoading = false
                    }
                }
            }
        }

        private func contentView(user: User) -> some View {
            VStack {
                topBarView
            }
        }
    
    private var topBarView: some View {
        VStack {
            HStack {
                Button(action: {
                    selectedTab = 0
                }) {
                    VStack {
                        Text("Dashboard")
                            .foregroundColor(selectedTab == 0 ? .cyan : .white)
                            .frame(maxWidth: .infinity)
                        
                        Rectangle()
                            .fill(selectedTab == 0 ? Color.cyan : Color.clear)
                            .frame(height: 3)
                    }
                }
                
                Button(action: {
                    selectedTab = 1
                }) {
                    VStack {
                        Text("Equipos")
                            .foregroundColor(selectedTab == 1 ? .cyan : .white)
                            .frame(maxWidth: .infinity)
                        
                        Rectangle()
                            .fill(selectedTab == 1 ? Color.cyan : Color.clear)
                            .frame(height: 3)
                    }
                }
                Button(action: {
                    selectedTab = 2
                }) {
                    VStack {
                        Text("Competiciones")
                            .foregroundColor(selectedTab == 2 ? .cyan : .white)
                            .frame(maxWidth: .infinity)
                        
                        Rectangle()
                            .fill(selectedTab == 2 ? Color.cyan : Color.clear)
                            .frame(height: 3)
                    }
                }
            }
            .padding(.leading, 10)
            .padding(.trailing, 10)
            if selectedTab == 0 {
                DashboardScreenView()
            } else if selectedTab == 1 {
                TeamsScreenView()
            } else {
                NavigationView {
                    CompetitionsView(viewModel: CompetitionsViewModel(competitionsInformation: mockCompetitions))
                }
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
