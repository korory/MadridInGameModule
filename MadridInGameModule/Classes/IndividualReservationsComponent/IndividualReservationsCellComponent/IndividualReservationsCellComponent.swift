//
//  IndividualReservationsCellComponent.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 14/10/24.
//

import SwiftUI

enum IndividualReservationsCellOptions {
    case seeReservation
    case cancelReservarion
}

struct IndividualReservationsCellComponent: View {
    var consoleSelected = ""
    var date = ""
    var hours = [""]
    var onReservationPressed: (IndividualReservationsCellOptions, String, String, [String]) -> Void
    
    var body: some View {
        VStack (spacing: 40){
            HStack {
                titleSubtitleAndAlertComponent
                Spacer()
                seeReservationAndCancelComponent
            }
        }
    }
}

extension IndividualReservationsCellComponent {
    
    private var titleSubtitleAndAlertComponent: some View {
        VStack (alignment: .leading, spacing: 15){
            HStack {
                Image(systemName: "exclamationmark.triangle")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.yellow)
                    .padding(.top, 5)
                    .padding(.trailing, 5)
                
                VStack (alignment: .leading){
                    Text("Reserva - \(consoleSelected)")
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.white)
                        .padding(.bottom, 5)
                    
                    Text("Fecha: \(date)")
                        .font(.system(size: 15))
                        .foregroundStyle(Color.white)
                        .padding(.bottom, 2)
                    
                    Text(hours.count > 1
                         ? "Horas: \(hours.joined(separator: ", "))"
                         : "Hora: \(hours.joined(separator: ", "))")
                    .font(.system(size: 15))
                    .foregroundStyle(Color.white)
                }
            }
        }
    }
    
    private var seeReservationAndCancelComponent: some View {
        VStack (spacing: 20){
            Button {
                onReservationPressed(IndividualReservationsCellOptions.seeReservation, consoleSelected, date, hours)
            } label: {
                Text("Ver reserva")
            }
            
            Button {
                onReservationPressed(IndividualReservationsCellOptions.cancelReservarion, consoleSelected, date, hours)
            } label: {
                Text("Cancelar")
                    .foregroundStyle(Color.red)
            }
        }
    }
}
