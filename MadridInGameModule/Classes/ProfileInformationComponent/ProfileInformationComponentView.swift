//
//  ProfileInformationComponentView.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 11/10/24.
//

import SwiftUI

struct ProfileInformationComponentView: View {
    var body: some View {
        ZStack {
            Color.black
                .opacity(0.7)
                .ignoresSafeArea(edges: .all)
            VStack (spacing: 40){
                ScrollView {
                    titleComponent
                    componentAvatarSelector
                    formComponent
                    buttonsDiscardSaveComponent
                }
            }
            .padding(.top, 10)
            .padding(.leading, 10)
            .padding(.trailing, 10)
        }
    }
}

extension ProfileInformationComponentView {
    
    private var titleComponent: some View {
        HStack (){
            Text("SOBRE MÍ")
                .font(.title)
                .bold()
                .foregroundStyle(Color.white)
            Spacer()
        }
    }
    
    private var formComponent: some View {
        VStack (alignment: .leading, spacing: 20){
            FloatingTextField(text: "", placeholderText: "Nombre")
                .onTextChange { oldValue, newValue in
                    
                }
            
            FloatingTextField(text: "", placeholderText: "Apellidos")
                .onTextChange { oldValue, newValue in
                    
                }
            
            FloatingTextField(text: "", placeholderText: "DNI")
                .onTextChange { oldValue, newValue in
                    
                }
            
            FloatingTextField(text: "", placeholderText: "Email")
                .onTextChange { oldValue, newValue in
                    
                }
            
            FloatingTextField(text: "", placeholderText: "Nick")
                .onTextChange { oldValue, newValue in
                    
                }
            
            FloatingTextField(text: "", placeholderText: "Teléfono (Opcional)")
                .onTextChange { oldValue, newValue in
                    
                }
        }
        .padding(.bottom, 20)
    }
    
    private var componentAvatarSelector: some View {
        AvatarComponentView(imageSelected: { image in })
            .padding(.bottom, 20)
    }
    
    private var buttonsDiscardSaveComponent: some View {
        HStack (spacing: 10){
            CustomButton(text: "Descartar",
                         needsBackground: false,
                         backgroundColor: Color.cyan,
                         pressEnabled: true,
                         widthButton: 170, heightButton: 40) {

            }
                         .padding(.trailing, 10)
            CustomButton(text: "Guardar",
                         needsBackground: true,
                         backgroundColor: Color.cyan,
                         pressEnabled: true,
                         widthButton: 170, heightButton: 40) {

            }
        }
    }
}

#Preview {
    ProfileInformationComponentView()
}
