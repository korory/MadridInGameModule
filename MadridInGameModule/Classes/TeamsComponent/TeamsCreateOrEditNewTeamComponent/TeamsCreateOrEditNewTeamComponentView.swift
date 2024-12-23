//
//  TeamsCreateNewTeamComponentView.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 14/10/24.
//

import SwiftUI

struct TeamsCreateOrEditNewTeamComponentView: View {
    @State var team: TeamModel?
    var editTeam: Bool = false
    @State var buttonCreateIsCorrect: Bool = false
    let action: (TeamModel) -> Void
    
    var body: some View {
        VStack(spacing: 15) {
            titleComponent
            if !buttonCreateIsCorrect {
                componentAvatarSelector
                formComponent
                buttonCreateComponent
            } else {
                sucessTeamCreateTextComponent
                buttonCreateComponent
            }
        }
    }
}

extension TeamsCreateOrEditNewTeamComponentView {
    private var titleComponent: some View {
        VStack (alignment: .leading) {
            Text(editTeam ? "EDITAR EQUIPO" : buttonCreateIsCorrect ? "EQUIPO CREADO" : "CREAR EQUIPO")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(Color.white)
        }
    }
    
    private var sucessTeamCreateTextComponent: some View {
        VStack (alignment: .leading) {
            Text("Una vez aprobemos la creación del equipo este aparecerá en tu lista de equipo")
                .font(.body)
                .fontWeight(.bold)
                .foregroundStyle(Color.white)
        }
    }
    
    private var componentAvatarSelector: some View {
        AvatarComponentView(externalImage: team?.image, imageSelected: { imageSelection in
            self.team?.image = imageSelection
        })
        .padding(.bottom, 20)
    }
    
    private var formComponent: some View {
        VStack (spacing: 28){
            FloatingTextField(text: team?.name ?? "", placeholderText: "Nombre *")
                .onTextChange { oldValue, newValue in
                    self.team?.name = newValue
                }
            FloatingTextField(text: team?.descriptionText ?? "", placeholderText: "Description *", isDescripcionTextfield: true)
                .onTextChange { oldValue, newValue in
                    self.team?.descriptionText = newValue
                }
            FloatingTextField(text: team?.discordLink ?? "", placeholderText: "Enlace Discord")
                .onTextChange { oldValue, newValue in
                    self.team?.discordLink = newValue
                }
        }
    }
    
    private var buttonCreateComponent: some View {
        CustomButton(text: editTeam ? "Editar" : buttonCreateIsCorrect ? "Aceptar" : "Crear",
                     needsBackground: true,
                     backgroundColor: Color.cyan,
                     pressEnabled: true,
                     widthButton: 120, heightButton: 50) {
            if !editTeam && !buttonCreateIsCorrect {
                buttonCreateIsCorrect.toggle()
            } else {
                guard let checkTeam = team else { return }
                action(checkTeam)
            }
        }
                     .padding()
    }
}
