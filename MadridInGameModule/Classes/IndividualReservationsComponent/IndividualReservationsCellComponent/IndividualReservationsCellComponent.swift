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
    var reservation: Reservation
    var onReservationPressed: (IndividualReservationsCellOptions, Reservation) -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                iconAndDetailsComponent
                Spacer()
                actionButtonsComponent
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(12)
        }
    }
}

extension IndividualReservationsCellComponent {
    private var iconAndDetailsComponent: some View {
        HStack(spacing: 12) {
            // Ícono de reserva
            Image(systemName: "gamecontroller")
                .resizable()
                .frame(width: 32, height: 32)
                .foregroundStyle(Color.cyan)
            
            // Detalles de la reserva
            VStack(alignment: .leading, spacing: 6) {
                Text("Reserva - \(reservation.slot.space)")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text("Fecha: \(reservation.date.formatted(date: .numeric, time: .omitted))")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                
                Text("Horas: \(reservation.times.map { $0.time }.joined(separator: ", "))")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }
        }
    }
    
    private var actionButtonsComponent: some View {
        VStack(spacing: 12) {
            // Botón para ver la reserva
            Button {
                onReservationPressed(.seeReservation, reservation)
            } label: {
                Text("Ver reserva")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.cyan)
            }
            
            // Botón para cancelar la reserva
            Button {
                onReservationPressed(.cancelReservation, reservation)
            } label: {
                Text("Cancelar")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.red)
            }
        }
    }
}
