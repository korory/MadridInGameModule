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
                
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(allTeams, id: \.id) { team in
                            Button(action: {
                                onTeamSelected(team)
                            }) {
                                Text(team.name ?? "Equipo sin nombre")
                                    .font(.custom("Madridingamefont-Regular", size: 15))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.cyan)
                                    .cornerRadius(12)
                                    .shadow(color: Color.cyan.opacity(0.5), radius: 5, x: 0, y: 3)
                                    .padding(.horizontal, 30)
                            }
                            .buttonStyle(ScaleButtonStyle())
                        }
                    }
                    
                }
                .frame(height: 280)
                .scrollIndicators(.visible)
                
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
