import SwiftUI

struct ReservationCardComponent: View {
    @ObservedObject var viewModel: ReservationCardViewModel
    @Environment(\.presentationMode) var presentationMode

    @State private var shineOffset: CGSize = .zero

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
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.gray.opacity(0.4))
                        .padding(10)
                }
                .padding()
            }
            .onAppear {
                viewModel.originalBrightness = UIScreen.main.brightness
                UIScreen.main.brightness = 1.0
            }

            VStack {
                Text("Madrid in game".localized)
                    .font(.madridInGameiOSFont(size: 25))
                    .foregroundColor(.white)
                    .padding(.top, 20)

                ZStack {
                    if viewModel.isFlipped {
                        VStack {
                            cardBase(showEffects: false) {
                                VStack(spacing: 10) {
                                    Text("Normas de uso".localized)
                                        .font(.madridInGameiOSFont(size: 20))
                                        .foregroundColor(.white)
                                    imageNormasUso(rulesSize)
                                }
                                .padding()
                                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                            }
                        }
                    } else {
                        VStack {
                            cardBase(showEffects: true) {
                                VStack(spacing: 10) {
                                    titleSubtitle
                                    imageReservationQr(imageSize)
                                    if !viewModel.getAllPlayers().isEmpty {
                                        playersCarouselComponent
                                    }
                                }
                                .padding()
                            }
                        }
                    }
                }
                .frame(width: size.width * 0.9, height: size.height * 0.7)
                .rotation3DEffect(
                    .degrees(viewModel.isFlipped ? -180 : viewModel.rotationY),
                    axis: (x: 0, y: 1, z: 0),
                    perspective: 0.5
                )
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            viewModel.rotationY = Double(value.translation.width / 5)
                            shineOffset = value.translation
                        }
                        .onEnded { _ in
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                                if abs(viewModel.rotationY) > 90 {
                                    viewModel.isFlipped.toggle()
                                }
                                viewModel.rotationY = 0
                                shineOffset = .zero
                            }
                        }
                )

                if !viewModel.checkIfReservationIsVirtual() {
                    CustomButton(
                        text: viewModel.isFlipped ? "Detalles".localized : "Normas de uso".localized,
                        needsBackground: true,
                        backgroundColor: Color.cyan,
                        pressEnabled: true,
                        widthButton: 165, heightButton: 50
                    ) {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            viewModel.isFlipped.toggle()
                            viewModel.rotationY = viewModel.isFlipped ? 180 : 0
                        }
                    }
                    .padding(.top, 20)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    // MARK: - Card base

    private func cardBase<Content: View>(showEffects: Bool = false, @ViewBuilder content: () -> Content) -> some View {
        ZStack {
            // Fondo original
            Rectangle()
                .fill(LinearGradient(
                    gradient: Gradient(colors: [.pink, .purple]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))

            if showEffects {
                // Reflejo holográfico que sigue el dedo
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(
                        RadialGradient(
                            colors: [.white.opacity(0.25), .clear],
                            center: UnitPoint(
                                x: 0.5 + shineOffset.width / 500,
                                y: 0.4 + shineOffset.height / 500
                            ),
                            startRadius: 0,
                            endRadius: 250
                        )
                    )

                // Borde sutil brillante
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [
                                .white.opacity(0.4),
                                .white.opacity(0.1),
                                .white.opacity(0.3)
                            ],
                            startPoint: UnitPoint(
                                x: shineOffset.width / 400,
                                y: 0
                            ),
                            endPoint: UnitPoint(
                                x: 1 + shineOffset.width / 400,
                                y: 1
                            )
                        ),
                        lineWidth: 1
                    )
            }

            content()

            if showEffects {
                // Watermark holográfico — solo visible al mover, posicionado abajo
                VStack {
                    Spacer()
                    Text("MADRID IN GAME")
                        .font(.system(size: 28, weight: .black))
                        .tracking(4)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [
                                    .clear,
                                    .white.opacity(shineOffset == .zero ? 0 : 0.2),
                                    .white.opacity(shineOffset == .zero ? 0 : 0.35),
                                    .white.opacity(shineOffset == .zero ? 0 : 0.2),
                                    .clear
                                ],
                                startPoint: UnitPoint(
                                    x: 0.0 + shineOffset.width / 250,
                                    y: 0.0
                                ),
                                endPoint: UnitPoint(
                                    x: 1.0 + shineOffset.width / 250,
                                    y: 1.0
                                )
                            )
                        )
                        .allowsHitTesting(false)
                        .padding(.bottom, 20)
                }
                .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
            }
        }
        .shadow(color: .purple.opacity(0.3), radius: 15, y: 8)
    }
}

extension ReservationCardComponent {

    private var titleSubtitle: some View {
        VStack(spacing: 10) {
            Text("Reserva Confirmada".localized)
                .font(.madridInGameiOSFont(size: 20))
                .foregroundColor(.white)

            Text("Localización: %@".localized(viewModel.getIfReservationIscenterOrVirtualText()))
                .font(.madridInGameiOSFont(size: 15))
                .foregroundColor(.white.opacity(0.8))

            Text("Fecha: %@".localized(viewModel.parseReservationDate()))
                .font(.madridInGameiOSFont(size: 15))
                .foregroundColor(.white.opacity(0.8))

            Text(viewModel.checkIfReservationIsVirtual()
                 ? "Hora: %@".localized(viewModel.getAllReservationTimes().joined(separator: ", "))
                 : "Horas: %@".localized(viewModel.getAllReservationTimes().joined(separator: ", ")))
                .font(.madridInGameiOSFont(size: 15))
                .foregroundColor(.white.opacity(0.8))
        }
    }

    private func imageReservationQr(_ imageSize: CGFloat) -> some View {
        if let qrImage = viewModel.myReserve?.qrImage {
            return AnyView(
                AsyncImage(url: URL(string: "\(viewModel.environmentManager.getBaseURL())/assets/\(qrImage)")) { phase in
                    switch phase {
                    case .empty:
                        VStack {
                            Image(uiImage: UserDefaults.getLogoMIG() ?? UIImage(systemName: "")!)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 50)

                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                                .scaleEffect(1.5)
                                .padding()

                            Text("Cargando QR...".localized)
                                .font(.madridInGameiOSFont(size: 15))
                                .foregroundColor(.white)
                                .opacity(0.7)
                        }
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: imageSize, height: imageSize)
                            .clipShape(RoundedRectangle(cornerRadius: 10.0))
                            .shadow(color: .white.opacity(0.15), radius: 8)
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
        } else {
            return AnyView(
                VStack(spacing: 20) {
                    Image(systemName: "qrcode.viewfinder")
                        .resizable()
                        .scaledToFit()
                        .frame(width: imageSize, height: imageSize)
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.top, 10)
                    Text("No se requiere QR".localized)
                        .font(.madridInGameiOSFont(size: 15))
                        .foregroundColor(.white)
                }
            )
        }
    }

    private func imageNormasUso(_ imageSize: CGFloat) -> some View {
        AsyncImage(url: URL(string: "https://webesports.madridingame.es/_next/static/media/reserve-rules.e49650ad.png")) { phase in
            switch phase {
            case .empty:
                VStack {
                    Image(uiImage: UserDefaults.getLogoMIG() ?? UIImage(systemName: "")!)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 50)

                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                        .scaleEffect(1.5)
                        .padding()

                    Text("Cargando Normas de Uso...".localized)
                        .font(.madridInGameiOSFont(size: 15))
                        .foregroundColor(.white)
                        .opacity(0.7)
                }
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
    }

    private var playersCarouselComponent: some View {
        VStack(alignment: .leading) {
            Text("Players".localized)
                .font(.madridInGameiOSFont(size: 12))
                .foregroundStyle(.white)
                .padding(.top, 4)
                .padding(.leading, 2)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(viewModel.getAllPlayers()) { player in
                        VStack {
                            if let avatar = player.userId?.avatar, !avatar.isEmpty {
                                AsyncImage(url: URL(string: "\(viewModel.environmentManager.getBaseURL())/assets/\(avatar)")) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                            .frame(width: 50, height: 50)
                                            .tint(.purple)
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 35, height: 35)
                                            .clipShape(Circle())
                                    case .failure:
                                        Image(systemName: "person.circle")
                                            .resizable()
                                            .cornerRadius(15)
                                            .frame(width: 35, height: 35)
                                            .clipShape(Circle())
                                            .foregroundColor(.white)
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                            } else {
                                Image(systemName: "person.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 35, height: 35)
                                    .clipShape(Circle())
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
            }
            .padding(.leading, 4)
            .padding(7)
        }
    }
}
