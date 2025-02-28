//
//  TeamsComponentView.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 14/10/24.
//

import SwiftUI

struct TeamsComponentView: View {
    @StateObject var viewModel: TeamsComponentViewModel

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.black, Color.black, Color.white.opacity(0.15)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(.all)
            
            VStack (spacing: 20){
                titleBanner
                cellTeamsComponent
                applyForAdmissionComponent
            }
            .padding()
            
//            CustomPopup(isPresented: Binding(
//                get: { viewModel.createTeamButtonPressed },
//                set: { viewModel.createTeamButtonPressed = $0 }
//            )) {
//                TeamsCreateOrEditNewTeamComponentView(action: { teamSelected in
//                    self.viewModel.addTeamIntoTeamList(newTeam: teamSelected)
//                    self.viewModel.createTeamButtonPressed = false
//                })
//            }
//            .transition(.scale)
//            .zIndex(1)
//            
//            CustomPopup(isPresented: Binding(
//                get: { viewModel.isEditTeamPressed },
//                set: { viewModel.isEditTeamPressed = $0 }
//            )) {
//                TeamsCreateOrEditNewTeamComponentView(team: viewModel.allTeams?.first, editTeam: true, action: { teamSelected in
//                    self.viewModel.editInformationTeamExists(updateTeam: teamSelected)
//                    self.viewModel.isEditTeamPressed = false
//                })
//            }
//            .transition(.scale)
//            .zIndex(1)
            
            CustomPopup(isPresented: Binding(
                get: { viewModel.applyForAdmisionButtonPressed },
                set: { viewModel.applyForAdmisionButtonPressed = $0 }
            )) {
                TeamsApplyForAdmisionComponentView()
            }
            .transition(.scale)
            .zIndex(1)
        }
    }
}

extension TeamsComponentView {
    private var titleBanner: some View {
        HStack {
            Text(viewModel.isUserMode ? "EQUIPOS": "EQUIPO")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(Color.white)
            
            Spacer()
            
            if viewModel.isUserMode {
                Button {
                    print("Create Team")
                    viewModel.createTeamButtonPressed.toggle()
                } label: {
                    HStack {
                        Text(viewModel.isUserMode ? "Crear Equipo" : "Editar")
                            .font(.system(size: 17))
                            .bold()
                            .foregroundStyle(Color.white)
                        
                        Image(systemName: "arrow.up.right")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .foregroundStyle(Color.white)
                    }
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                }
            }
        }
       
    }
    
    private var applyForAdmissionComponent: some View {
        VStack (spacing: 40){
            CustomButton(text: "Solicitar ingreso",
                         needsBackground: false,
                         backgroundColor: Color.cyan,
                         pressEnabled: true,
                         widthButton: 250, heightButton: 30) {
                viewModel.applyForAdmisionButtonPressed.toggle()
            }
            
            CustomButton(text: "No tienes invitaciones",
                         needsBackground: true,
                         backgroundColor: Color.white.opacity(0.7),
                         pressEnabled: true,
                         widthButton: 250, heightButton: 30) {
                
            }
        }
        .padding()
    }
    
    private var cellTeamsComponent: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.allTeams ?? [], id: \.id) { team in
                    TeamsComponentCellView(teamSelected: team, isUserMode: viewModel.isUserMode, editButtonPressed: { teamSelected in
                        self.viewModel.isEditTeamPressed = true
                    })
                    .padding(.leading, 5)
                    .padding(.trailing, 5)
                    .padding(.bottom, 5)
                }
            }
        }
    }
}
