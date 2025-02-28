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
                arrowPress
            }
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
                .padding(.leading, 10)
                .padding(.trailing, 2)
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
            .padding(.leading, 10)
            .padding(.trailing, 2)
            )
        }
    }
    
    private var titleSubtitle: some View {
        VStack (alignment: .leading, spacing: 10){
            Text(team.name ?? "Equipo sin nombre")
                .font(.custom("Madridingamefont-Regular", size: 17))
                .foregroundColor(.white)
                .padding(.leading, 8)
            
            Text(team.description ?? "Sin Descripción")
                .font(.system(size: 14))
                .lineLimit(4)
                .foregroundColor(.white)
                .padding(.leading, 8)
        }
    }
    
    private var arrowPress: some View {
        Image(systemName: "chevron.right") // Flecha que indica interacción
            .resizable()
            .frame(width: 5, height: 10)
            .foregroundColor(.white)
            .padding(.leading, 10)
            .padding(.trailing, 10)

    }
}
