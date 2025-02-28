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
            
            Text("ESPACIO RESERVADO")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(Color.white)
            
            Text("Fecha: \(dateSelected)")
                .font(.headline)
                .foregroundStyle(Color.white)
                .padding(.leading, 10)
            
            Text(hoursSelected.count > 1
                 ? "Horas: \(hoursSelected.joined(separator: ", "))"
                 : "Hora: \(hoursSelected.joined(separator: ", "))")
            .font(.headline)
            .foregroundStyle(Color.white)
            .padding(.leading, 10)
            
            
            Text("Consola: \(consoleSelected)")
                .font(.headline)
                .foregroundStyle(Color.white)
                .padding(.leading, 10)
        }
    }
    
    
    private var qrImageComponent: some View {
        VStack (spacing: 25){
            Text("Puedes usar este QR para acceder.")
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
            
            Text("Código: \(code)")
                .font(.body)
                .foregroundStyle(Color.white)
                .padding(.bottom, 15)
        }
    }
    
    private var rulesDropdownComponent: some View {
        DropdownComponentView(dropdownText: "Normas de uso")
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
            
            
            Text("Importante: Debes llevar tu DNI contigo para poder acceder al centro la primera vez para validar tu usuario")
                .font(.body)
                .foregroundStyle(Color.white)
        }
        
    }
    
    private var acceptButton: some View {
        CustomButton(text: "Aceptar",
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
