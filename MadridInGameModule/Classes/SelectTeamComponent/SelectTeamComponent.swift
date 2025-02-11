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
            // Fondo con degradado
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.black, Color.black, Color.black.opacity(0.9)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("¿Qué equipo quieres gestionar?")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(allTeams, id: \.id) { team in
                            Button(action: {
                                onTeamSelected(team)
                            }) {
                                Text(team.name ?? "Equipo sin nombre")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.cyan)
                                    .cornerRadius(12)
                                    .shadow(color: Color.cyan.opacity(0.5), radius: 5, x: 0, y: 3)
                                    .padding(.horizontal, 30)
                            }
                            .buttonStyle(ScaleButtonStyle()) // Efecto visual al presionar
                        }
                    }
                    
                }
                .frame(height: 280)
                .scrollIndicators(.visible)
                
                Spacer()
                
                //                // Botón de cerrar
                //                Button(action: {
                //                    isPresented = false
                //                }) {
                //                    Image(systemName: "xmark.circle.fill")
                //                        .resizable()
                //                        .frame(width: 40, height: 40)
                //                        .foregroundColor(.white.opacity(0.8))
                //                }
                //                .padding(.bottom, 30)
            }
        }
    }
}

// Estilo de botón con animación de escala
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}


//import SwiftUI
//
//struct SelectTeamComponent: View {
//    @Binding var isPresented: Bool
//    var userManager = UserManager.shared
//
//    var body: some View {
//        ZStack(alignment: .center) {
//            Color.black
//                .ignoresSafeArea(edges: .all)
//
//            VStack {
//                Spacer()
//                Text("¿Que equipo quieres gestionar?")
//                    .foregroundStyle(.white)
//                    .padding(.bottom, 20)
//
//
//                ScrollView {
//                    if let teams = userManager.getUser()?.teams {
//                        ForEach(teams, id: \.id) { team in
//                            CustomButton(
//                                text: team.name ?? "No Name Team",
//                                needsBackground: true,
//                                backgroundColor: Color.cyan,
//                                pressEnabled: true,
//                                widthButton: 250,
//                                heightButton: 30
//                            ) {
//                                print("Seleccionaste \(String(describing: team.name))")
//                            }
//                            .padding()
//                        }
//                    }
//                }
//                .frame(height: 400)
//                Spacer()
//            }
//        }
//    }
//}
