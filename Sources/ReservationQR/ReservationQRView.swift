//
//  ReservationQRView.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 10/10/24.
//

import SwiftUI

struct ReservationQRView: View {
    var dateSelected = ""
    var hoursSelected: [String] = []
    var consoleSelected = ""
    var code = ""
    let action: () -> Void
    
    var body: some View {
        VStack (spacing: 15){
            ScrollView {
                titleSubtitleComponent
                qrImageComponent
                rulesDropdownComponent
                importantMessageComponent
                acceptButton
            }
        }
    }
}

extension ReservationQRView {
    
    private var titleSubtitleComponent: some View {
        VStack (alignment: .leading, spacing: 12) {
            
            Text("dashboard.teams.teamAreas.reserves.reservedSpace".localized)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(Color.white)
            
            Text("Fecha: %@".localized(dateSelected))
                .font(.headline)
                .foregroundStyle(Color.white)
                .padding(.leading, 10)
            
            Text(hoursSelected.count > 1
                 ? "Horas: %@".localized(hoursSelected.joined(separator: ", "))
                 : "Hora: %@".localized(hoursSelected.joined(separator: ", ")))
            .font(.headline)
            .foregroundStyle(Color.white)
            .padding(.leading, 10)
            
            
            Text("Consola: %@".localized(consoleSelected))
                .font(.headline)
                .foregroundStyle(Color.white)
                .padding(.leading, 10)
        }
    }
    
    
    private var qrImageComponent: some View {
        VStack (spacing: 25){
            Text("dashboard.teams.teamAreas.reserves.qrUsage".localized)
                .font(.body)
                .foregroundStyle(Color.white)
                .padding(.top, 10)

            
            Image(systemName: "qrcode")
                .resizable()
                .frame(width: 185, height: 185)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(Color.white)
                        .frame(width: 200, height: 200)
                )
            
            Text("Código: %@".localized(code))
                .font(.body)
                .foregroundStyle(Color.white)
                .padding(.bottom, 15)
        }
    }
    
    private var rulesDropdownComponent: some View {
        DropdownComponentView(dropdownText: "dashboard.teams.teamAreas.reserves.reserveTerms".localized)
            .padding(.bottom, 15)
    }
    
    private var importantMessageComponent: some View {
        HStack (spacing: 20){
            VStack {
                Image(systemName: "exclamationmark.triangle")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.yellow)
                    .padding(.top, 5)
                Spacer()
            }
            
            
            Text("dashboard.teams.teamAreas.reserves.reserveIdRequired".localized)
                .font(.body)
                .foregroundStyle(Color.white)
        }
        
    }
    
    private var acceptButton: some View {
        CustomButton(text: "dashboard.teams.accept".localized,
                     needsBackground: true,
                     backgroundColor: Color.cyan,
                     pressEnabled: true,
                     widthButton: 180, heightButton: 50) {
            action()
        }
                     .padding(10)
    }
}

#Preview {
    ReservationQRView(action: {})
}
