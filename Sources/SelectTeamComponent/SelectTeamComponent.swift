//
//  SelectTeamComponent.swift
//  Pods
//
//  Created by Arnau Rivas Rivas on 7/2/25.
//

import SwiftUI

struct SelectTeamComponent: View {
    var allTeams: [TeamModelReal]
    var onTeamSelected: (TeamModelReal) -> Void
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.black, Color.black, Color.white.opacity(0.15)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(.all)
            
            VStack {
                Spacer()
                
                Text("¿Qué equipo quieres gestionar?")
                    .font(.custom("Madridingamefont-Regular", size: 20))
                    .bold()
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.bottom, 15)
                    .padding(.top, 20)
                
                RoundedRectangle(cornerRadius: 10.0)
                    .frame(height: 2)
                    .foregroundStyle(.white.opacity(0.1))
                
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(allTeams, id: \.id) { team in
                            VStack {
                                SelectTeamsCellComponent(team: team) { teamSelected in
                                    onTeamSelected(teamSelected)
                                }
                                .padding(.leading, 10)
                                
                                RoundedRectangle(cornerRadius: 10.0)
                                    .frame(height: 2)
                                    .foregroundStyle(.white.opacity(0.1))
                                    .padding(.leading, 10)
                                    .padding(.trailing, 10)
                            }
                        }
                    }
                    
                }
                .scrollIndicators(.visible)
                .padding(.top, 10)
                
                Spacer()
            }
        }
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
