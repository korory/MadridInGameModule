//
//  TeamsComponentCellView.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 14/10/24.
//

import SwiftUI

struct TeamsComponentCellView: View {
    let teamSelected: TeamModel
    let isUserMode: Bool
    let editButtonPressed: (TeamModel) -> Void
    
    var body: some View {
        HStack {
            avatarComponent
            VStack {
                titleSubtitleComponent
            }
            Spacer()
            if !isUserMode {
                editButtonComponent
            }
        }
        .padding(.top, 10)
    }
}

extension TeamsComponentCellView {
    private var avatarComponent: some View {
        Image(uiImage: teamSelected.image)
            .resizable()
            .frame(width: 58, height: 58)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.gray, lineWidth: 4))
    }
    
    private var titleSubtitleComponent: some View {
        VStack (alignment: .leading, spacing: 5){
            Text(teamSelected.name)
                .font(.system(size: 20))
                .fontWeight(.bold)
                .foregroundStyle(Color.white)
                .lineLimit(1)
            
            Text(teamSelected.descriptionText)
                .font(.system(size: 12))
                .foregroundStyle(Color.white)
                .lineLimit(1)
        }
        .padding(.leading, 5)
    }
    
    private var editButtonComponent: some View {
        Button {
            editButtonPressed(teamSelected)
        } label: {
            Image(systemName: "pencil.circle.fill")
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundStyle(Color.cyan)
                .clipShape(Circle())
        }
    }
}




