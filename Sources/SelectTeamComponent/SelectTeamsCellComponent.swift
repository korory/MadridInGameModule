//
//  SelectTeamsCellComponent.swift
//  Pods
//
//  Created by Arnau Rivas Rivas on 25/2/25.
//

import SwiftUI

struct SelectTeamsCellComponent: View {
    var team: TeamModelReal
    var onTeamSelected: (TeamModelReal) -> Void
    
    public var body: some View {
        VStack {
            HStack {
                teamImage
                titleSubtitle
                Spacer()
                if UserManager.shared.getSelectedTeam()?.id == team.id {
                    selectedTeam
                }
            }
            .padding()
                .cornerRadius(20)
                .background(Color.gray.opacity(0.5))
        }
        .background(Color.black.opacity(0.9))
        .cornerRadius(20)
        .shadow(radius: 2)
        .onTapGesture {
            onTeamSelected(team)
        }
    }
}

extension SelectTeamsCellComponent {
    
    private var teamImage: some View {
        let environmentManager = EnvironmentManager()
        
        if let pictureId = team.picture {
            return AnyView(
                AsyncImage(url: URL(string: "\(environmentManager.getBaseURL())/assets/\(pictureId)")) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 50, height: 50)
                            .tint(.purple)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 70, height: 70)
                            .clipShape(Circle())
                            .padding()
                    case .failure:
                        Image(systemName: "person.2.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 70, height: 70)
                            .clipShape(Circle())
                            .padding()
                    @unknown default:
                        EmptyView()
                    }
                }
            )
        } else {
            return AnyView(
                VStack (spacing: 20){
                    Image(systemName: "person.2.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                        .padding()
                }
            )
        }
    }
    
    private var titleSubtitle: some View {
        VStack (alignment: .leading, spacing: 10){
            Text(team.name ?? "Equipo sin nombre".localized)
                .font(.madridInGameiOSFont(size: 17))
                .foregroundColor(.white)
                .padding(.leading, 8)
            
            Text(team.description ?? "Sin Descripción".localized)
                .font(.system(size: 14))
                .lineLimit(4)
                .foregroundColor(.white)
                .padding(.leading, 8)
        }
    }
    
    private var selectedTeam: some View {
        Image(systemName: "checkmark.circle")
            .resizable()
            .frame(width: 30, height: 30)
            .foregroundColor(.white)
            .padding(.leading, 10)
            .padding(.trailing, 10)
        
    }
}
