//
//  IndividualReservationsCellComponent.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 14/10/24.
//

import SwiftUI

enum IndividualReservationsCellOptions {
    case seeReservation
    case cancelReservation
}

struct IndividualReservationsCellComponent: View {
    @StateObject var viewModel: IndividualReservationsCellViewModel
    let action: (_ optionSelected: TeamReservationCellComponentOptionSelected) -> Void

    var body: some View {
        VStack(spacing: 16) {
            iconAndDetailsComponent
            buttonsComponent

        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 3)
    }
}

extension IndividualReservationsCellComponent {
    private var iconAndDetailsComponent: some View {
        HStack(spacing: 14) {
            Image(systemName: "gamecontroller.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(.white)
                .padding(10)
                .background(Color.cyan)
                .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 8) {
                
                titleAndDeleteReservation

                Text(viewModel.parseReservationDate())
                    .font(.custom("Madridingamefont-Regular", size: 12))
                    .foregroundColor(.white.opacity(0.85))

                if !viewModel.reservation.times.isEmpty {
                    Text(viewModel.formatTimes())
                        .font(.custom("Madridingamefont-Regular", size: 12))
                        .foregroundColor(.white.opacity(0.7))
                }
            }
        }
    }
    
    private var titleAndDeleteReservation: some View {
        HStack {
            
            Text("Reserva - \(viewModel.getReservationConsole())")
                .font(.custom("Madridingamefont-Regular", size: 15))
                .fontWeight(.bold)
                .foregroundColor(.white)
            
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
        }
        .padding(.top, 10)
    }
//    private var actionButtonsComponent: some View {
//        VStack(spacing: 10) {
//            // Botón para ver la reserva
//            Button {
//                // onReservationPressed(.seeReservation, reservation)
//            } label: {
//                Text("Ver reserva")
//                    .font(.system(size: 14, weight: .bold))
//                    .foregroundColor(.cyan)
//                    .padding(.horizontal, 12)
//                    .padding(.vertical, 6)
//                    .background(Color.white.opacity(0.1))
//                    .cornerRadius(8)
//            }
//        }
//    }
}
