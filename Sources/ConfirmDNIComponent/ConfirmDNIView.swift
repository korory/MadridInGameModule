//
//  ConfirmDNIView.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 10/10/24.
//

import SwiftUI

struct ConfirmDNIView: View {
    let action: (String) -> Void
    @State private var dni: String = ""
    @State private var isDNIValid: Bool = true
    @State private var errorMessage: String? = nil
    
    var body: some View {
        VStack{
            titleAndSubtitleComponent
            textComponent
            acceptButton
        }
    }
}

extension ConfirmDNIView {
    private var titleAndSubtitleComponent: some View {
        VStack {
            Text("Confirma tu DNI")
                .font(.title)
                .foregroundStyle(Color.white)
            
            FloatingTextField(text: "", placeholderText: "DNI")
                .onTextChange { oldValue, newValue in
                    dni = newValue
                    isDNIValid = validateDNI(newValue)
                    
                    // Actualiza el mensaje de error
                    if !isDNIValid {
                        errorMessage = "El DNI debe tener 8 dígitos seguidos de una letra mayúscula."
                    } else {
                        errorMessage = nil // Restablece el mensaje de error si el DNI es válido
                    }
                }
                //.setErrorMessage(errorMessage)
            
            Text("Introduce y Confirma tu DNI")
                .font(.body)
                .foregroundStyle(Color.white)
                .padding(.top, 10)
        }
    }
    
    private var textComponent: some View {
        Text("Importante: Debes llevar tu DNI contigo para poder acceder al centro la primera vez para validar tu usuario")
            .font(.body)
            .foregroundStyle(Color.white)
    }
    
    private var acceptButton: some View {
        CustomButton(text: "Aceptar",
                     needsBackground: true,
                     backgroundColor: Color.cyan,
                     pressEnabled: true,
                     widthButton: 180, heightButton: 50) {
            action(dni)
        }
                     .padding(10)
                     //.disabled(!isDNIValid) //TODO: Add this
    }
    
    private func validateDNI(_ dni: String) -> Bool {
        let dniRegex = "^[0-9]{8}[A-Z]$"
        let dniTest = NSPredicate(format: "SELF MATCHES %@", dniRegex)
        return dniTest.evaluate(with: dni)
    }
}

#Preview {
    ConfirmDNIView(action: {_ in })
        .background(Color.blue)
        .ignoresSafeArea()
}

