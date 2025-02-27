//
//  PlayerTeamComponentCell.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 17/10/24.
//

import SwiftUI

struct PlayerTeamComponentCell: View {
    let playerInformation: TeamUser
        
    var body: some View {
        VStack {
            HStack {
                playerAvatarImage
                playerUsernameAndRole
                Spacer()
            }
        }
        .background(Color.white.opacity(0.1))
        .cornerRadius(20)
        .shadow(radius: 2)
    }
}

extension PlayerTeamComponentCell {
    
    private var playerAvatarImage: some View {
        let environmentManager = EnvironmentManager()
        
            return AnyView(
                AsyncImage(url: URL(string: "\(environmentManager.getBaseURL())/assets/\(playerInformation.usersId?.avatar)")) { phase in
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
        }
    
    private var playerUsernameAndRole: some View {
        VStack (alignment: .leading, spacing: 10){
            Text(playerInformation.usersId?.username ?? "No Username")
                .font(.custom("Madridingamefont-Regular", size: 17))
                .foregroundColor(.white)
                .padding(.leading, 8)
            
            Text(playerInformation.roles?.name ?? "No Role")
                .font(.system(size: 14))
                .lineLimit(4)
                .foregroundColor(.white)
                .padding(.leading, 8)
        }
        
    }
    
}
