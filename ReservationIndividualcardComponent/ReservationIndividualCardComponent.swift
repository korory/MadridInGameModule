//
//  ReservationIndividualCardComponent.swift
//  Pods
//
//  Created by Arnau Rivas Rivas on 20/2/25.
//

import SwiftUI

struct ReservationIndividualCardComponent: View {
    @ObservedObject var viewModel: ReservationIndividualCardViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let imageSize = size.width * 0.6
            let rulesSize = size.width * 0.7
            
            HStack {
                Spacer()
                Button {
                    UIScreen.main.brightness = viewModel.originalBrightness
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .frame(width: 28, height: 28)
                        .foregroundStyle(.white)
                }
                .padding()
            }
            .onAppear {
                viewModel.originalBrightness = UIScreen.main.brightness
                UIScreen.main.brightness = 1.0
            }
            
            VStack {
                Text("Madrid in game")
                    .font(.custom("Madridingamefont-Regular", size: 25))
                    .foregroundColor(.white)
                    .padding(.top, 20)
                
                ZStack {
                    if viewModel.isFlipped {
                        VStack {
                            Rectangle()
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: [.pink, .purple]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                                .shadow(radius: 10)
                                .overlay(
                                    VStack(spacing: 10) {
                                        Text("Normas de uso")
                                            .font(.custom("Madridingamefont-Regular", size: 20))
                                            .foregroundColor(.white)
                                        imageNormasUso(rulesSize)
                                        
                                    }
                                        .padding()
                                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                                )
                        }
                    } else {
                        VStack {
                            Rectangle()
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: [.pink, .purple]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                                .shadow(radius: 10)
                                .overlay(
                                    VStack(spacing: 10) {
                                        titleSubtitle
                                        imageReservationQr(imageSize)
                                            .padding(.bottom, 28)
                                    }
                                        .padding()
                                )
                        }
                    }
                }
                .frame(width: size.width * 0.9, height: size.height * 0.7)
                .rotation3DEffect(
                    .degrees(viewModel.isFlipped ? -180 : viewModel.rotationY),
                    axis: (x: 0, y: 1, z: 0)
                )
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            viewModel.rotationY = Double(value.translation.width / 5)
                        }
                        .onEnded { _ in
                            withAnimation {
                                if abs(viewModel.rotationY) > 90 {
                                    viewModel.isFlipped.toggle()
                                }
                                viewModel.rotationY = 0
                            }
                        }
                )
                // Botón para girar la tarjeta
                CustomButton(text: "Normas de uso",
                             needsBackground: true,
                             backgroundColor: Color.cyan,
                             pressEnabled: true,
                             widthButton: 165, heightButton: 50) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        viewModel.isFlipped.toggle()
                        viewModel.rotationY = viewModel.isFlipped ? 180 : 0
                    }
                    
                }
                             .padding(.top, 20)
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

extension ReservationIndividualCardComponent {
    
    private var titleSubtitle: some View {
        VStack (spacing: 10){
            Text("Reserva Confirmada")
                .font(.custom("Madridingamefont-Regular", size: 20))
                .foregroundColor(.white)
            
            Text("Localización: \(viewModel.getIfReservationIscenterOrVirtualText())")
                .font(.custom("Madridingamefont-Regular", size: 15))
                .foregroundColor(.white.opacity(0.8))
            
            Text("Plataforma: \(viewModel.getReservationConsole())")
                .font(.custom("Madridingamefont-Regular", size: 15))
                .foregroundColor(.white.opacity(0.8))
            
            Text("Fecha: \(viewModel.parseReservationDate())")
                .font(.custom("Madridingamefont-Regular", size: 15))
                .foregroundColor(.white.opacity(0.8))
            
            Text("Horas: \(viewModel.formatTimes())")
                .font(.custom("Madridingamefont-Regular", size: 15))
                .foregroundColor(.white.opacity(0.8))
            
        }
    }
    
    private func imageReservationQr(_ imageSize: CGFloat) -> some View {
        let qrValue = viewModel.reservation.qrImage;
        
        let environmentManager = EnvironmentManager()
        
        return AnyView(
            AsyncImage(url: URL(string: "\(environmentManager.getBaseURL())/\(qrValue ?? "")")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 50, height: 50)
                        .tint(.purple)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: imageSize, height: imageSize)
                        .clipShape(RoundedRectangle(cornerRadius: 10.0))
                        .padding()
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: imageSize, height: imageSize)
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
        )
    }
    
    private func imageNormasUso(_ imageSize: CGFloat) -> some View {
        
        let environmentManager = EnvironmentManager()

        return AnyView(
            AsyncImage(url: URL(string: "https://webesports.madridingame.es/_next/static/media/reserve-rules.e49650ad.png")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 50, height: 50)
                        .tint(.purple)
                case .success(let image):
                    image
                        .resizable()
                        .frame(width: 250, height: 400)
                        .clipShape(RoundedRectangle(cornerRadius: 10.0))
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .frame(width: imageSize, height: imageSize)
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
        )
        
    }
}
