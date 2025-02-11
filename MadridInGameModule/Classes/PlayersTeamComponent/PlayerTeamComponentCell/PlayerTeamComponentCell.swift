//
//  PlayerTeamComponentCell.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 17/10/24.
//

import SwiftUI

struct PlayerTeamComponentCell: View {
    let playerInformation: PlayerModel
    let allRolesAvailable: [String]
    
    let removeAction: (PlayerModel) -> Void
        
    var body: some View {
        HStack {
            avatarAndNamePlayerComponent
            Spacer()
            if !checkManagerRole() {
                removePlayerButton
            }
        }
        .padding(.leading, 5)
    }
    
    func checkManagerRole() -> Bool { // If player role is Manager we not enable to change this role
        return playerInformation.roleAssign == "Manager"
    }
    
    func checkSelectedRole(role: String) -> Bool {
        return role == playerInformation.roleAssign
    }
}

extension PlayerTeamComponentCell {
    
    private var avatarAndNamePlayerComponent: some View {
        HStack (spacing: 10){
            Image(uiImage: playerInformation.image)
                .resizable()
                .foregroundStyle(Color.white)
                .frame(width: 70, height: 70)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.gray, lineWidth: 4))
            
            let displayName = playerInformation.name.count > 8 ? "\(playerInformation.name.prefix(8))..." : playerInformation.name
            
            VStack (alignment: .leading){
                Text(displayName)
                    .font(.body .weight(.bold))
                    .foregroundStyle(Color.white)
                    .padding(.trailing, 10)
                
                //dropdownSelectPlayerRolesComponent
            }
        }
    }
    
//    private var dropdownSelectPlayerRolesComponent: some View {
//        let options = allRolesAvailable.map { DropdownSingleSelectionModel(title: $0, isOptionSelected: checkSelectedRole(role: $0)) }
//
//        return DropdownSingleSelectionComponentView(options: options, userInteraction: !checkManagerRole()) { selection in
//            print("czxcxz")
//        }
//    }
    
    private var removePlayerButton: some View {
        Button {
            removeAction(playerInformation)
        } label: {
            Image(systemName: "minus.circle")
                .resizable()
                .frame(width: 28, height: 28)
                .foregroundStyle(Color.red)
        }
        .padding(.leading, 10)
    }
    
}
