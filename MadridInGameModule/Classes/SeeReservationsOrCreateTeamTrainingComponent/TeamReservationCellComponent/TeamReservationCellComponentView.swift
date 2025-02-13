import SwiftUI

struct TeamReservationCellComponentView: View {
    @ObservedObject var viewModel: TeamReservationCellComponentViewModel
    let action: (_ optionSelected: TeamReservationCellComponentOptionSelected) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            iconDateAndRemoveBannerComponent
            playersCarouselComponent
            if viewModel.reservation.notes != "" {
                descriptionComponent
            }
            buttonsComponent
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}

extension TeamReservationCellComponentView {
    // Icono y fecha de la reserva
//    private var iconAndDateComponent: some View {
//        HStack {
//            Image(systemName: viewModel.getSystemImageNameOfReservationBasedOnType())
//                .resizable()
//                .scaledToFit()
//                .frame(width: 20, height: 20)
//                .foregroundStyle(Color.gray)
//                .padding(.trailing, 2)
//            
//            Text(viewModel.reservation.startDate)
//                .font(.custom("Madridingamefont-Regular", size: 15))
//                .foregroundStyle(Color.white)
//        }
//    }

//    // Botón para eliminar la reserva
//    private var removeReservationButton: some View {
//        Button {
//            action(.removeCell)
//        } label: {
//            Image(systemName: "trash")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 20, height: 20)
//                .foregroundStyle(Color.red)
//        }
//    }

//    // Información del slot asociado a la reserva
//    private var slotInfoComponent: some View {
//        HStack() {
//            Text("Slot:")
//                .font(.subheadline)
//                .foregroundColor(Color.cyan.opacity(0.8))
//                .fontWeight(.semibold)
//            
//            Text(viewModel.parseTimeDeleteSeconds())
//                .font(.custom("Madridingamefont-Regular", size: 15))
//                .foregroundColor(Color.gray)
//        }
//    }
    
    private var iconDateAndRemoveBannerComponent: some View {
        HStack (spacing: 10){
            Image(systemName: viewModel.getSystemImageNameOfReservationBasedOnType())
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundStyle(Color.gray)
                .padding(.trailing, 2)
            
            Text(viewModel.parseReservationDate() + " - " + viewModel.parseTimeDeleteSeconds())
                .font(.custom("Madridingamefont-Regular", size: 17))
                .foregroundStyle(Color.white)
            
            Spacer()
            
            Button {
                action(.removeCell)
            } label: {
                Image(systemName: "minus.circle")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(Color.red)
            }
        }
    }
    
    private var playersCarouselComponent: some View {
        VStack (alignment: .leading){
        
            Text("Players")
                .font(.custom("Madridingamefont-Regular", size: 12))
                .foregroundStyle(.white)
                .padding(.top, 4)
                .padding(.leading, 2)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(viewModel.getAllPlayers()) { player in
                        VStack {
                            if let avatar = player.userId?.avatar, !avatar.isEmpty {
                                AsyncImage(url: URL(string: "https://premig.randomkesports.com/cms/assets/\(avatar)")) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                            .frame(width: 50, height: 50)
                                            .tint(.purple)
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 35, height: 35)
                                            .clipShape(Circle())
                                    case .failure:
                                        Image(systemName: "photo")
                                            .resizable()
                                            .cornerRadius(15)
                                            .frame(width: 280, height: 470)
                                            .foregroundColor(.gray)
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

    
    private var descriptionComponent: some View {
        VStack (alignment: .leading){
            Text("Notas")
                .font(.custom("Madridingamefont-Regular", size: 12))
                .foregroundStyle(.white)
                .padding(.top, 4)
            
            ScrollView {
                Text(viewModel.reservation.notes ?? "")
                    .font(.body)
                    .foregroundStyle(Color.white)
                    .lineLimit(nil)
            }
            .padding(.leading, 7)
            .frame(height: 70)
        }
        .padding(7)
    }

    // Horas de la reserva
//    private var hoursComponent: some View {
////        Text(viewModel.reservation.times.count > 1
////             ? "Horas: \(viewModel.reservation.times.map { $0.time }.joined(separator: ", "))"
////             : "Hora: \(viewModel.reservation.times.map { $0.time }.joined(separator: ", "))")
////            .font(.body)
////            .foregroundColor(.white)
//    }

    // Botones de acciones (ver detalles y editar)
    private var buttonsComponent: some View {
        HStack {
            Spacer()
            Button {
                action(.seeDetails)
            } label: {
                HStack {
                    Image(systemName: "eye")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 15)
                        .foregroundColor(.cyan)
                    Text("Ver reserva")
                        .font(.custom("Madridingamefont-Regular", size: 14))
                        .foregroundColor(.cyan)
                }
            }
            Spacer()
//            Button {
//                action(.editTraining)
//            } label: {
//                HStack {
//                    Image(systemName: "pencil")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(height: 12)
//                        .foregroundColor(.red)
//                    Text("Editar")
//                        .font(.custom("Madridingamefont-Regular", size: 14))
//                        .foregroundColor(.red)
//                }
//            }
//            Spacer()
        }
        .padding(.top, 10)
    }
}
