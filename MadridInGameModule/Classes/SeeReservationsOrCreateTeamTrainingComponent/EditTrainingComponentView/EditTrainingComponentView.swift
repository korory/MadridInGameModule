//
//  EditTrainingComponentView.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 16/10/24.
//

import SwiftUI

struct EditTrainingComponentView: View {
    let reservationModel: TeamReservationModel
    
    var body: some View {
        ScrollView {
            VStack (spacing: 20){
                titleBanner
                dropdownSelectPlayers
                notesComponent
                dateSelectedComponent
                consoleSelectedComponent
                hoursSelectedComponent
            }
        }
    }
}

extension EditTrainingComponentView {
    
    private var titleBanner: some View {
        Text("Editar Entrenamiento")
            .font(.title)
            .foregroundStyle(Color.white)
    }
    
    private var dropdownSelectPlayers: some View {
        VStack (alignment: .leading, spacing: 28){
            TextWithUnderlineComponent(title: "Jugadores Asignados", underlineColor: Color.cyan)
            
            DropdownMultipleSelectionComponentView(options: [
                DropdownMultipleSelectionModel(title: "Player 1", isOptionSelected: true),
                DropdownMultipleSelectionModel(title: "Player 2", isOptionSelected: true),
                DropdownMultipleSelectionModel(title: "Player 3", isOptionSelected: true),
                DropdownMultipleSelectionModel(title: "Player 4", isOptionSelected: true)
            ], optionPressed: { optionSelectedText in
                
            })
        }
        .padding(.leading, 10)
    }
    
    private var notesComponent: some View {
        VStack (alignment: .leading, spacing: 28){
            TextWithUnderlineComponent(title: "Notas", underlineColor: Color.cyan)

            FloatingTextField(text: "", placeholderText: "Notas (Optional)", isDescripcionTextfield: true)
        }
        .padding(.leading, 10)
    }
    
    private var dateSelectedComponent: some View {
        VStack (spacing: 28) {
            HStack {
                TextWithUnderlineComponent(title: "Fecha Seleccionada", underlineColor: Color.cyan)
                Spacer()
            }
            Text(reservationModel.dateSelected)
                .font(.title)
                .foregroundStyle(Color.white)
        }
        .padding(.leading, 10)
    }
    
    private var consoleSelectedComponent: some View {
        VStack (spacing: 28){
            HStack {
                TextWithUnderlineComponent(title: "Consola Seleccionada", underlineColor: Color.cyan)
                Spacer()
            }
            CustomButton(text: reservationModel.consoleSelected, needsBackground: false, backgroundColor: .white, pressEnabled: false, widthButton: 180, heightButton: 50) {}
        }
        .padding(.leading, 10)
    }
    
    private var hoursSelectedComponent: some View {
        VStack (spacing: 28){
            HStack {
                TextWithUnderlineComponent(title: reservationModel.hoursSelected.count > 1 ? "Horas Seleccionadas" : "Hora Seleccionada" , underlineColor: Color.cyan)
                Spacer()
            }
            CustomSelectorButtons(items: reservationModel.hoursSelected,
                                  selectedItems: .constant([""]), pressEnabled: false) { hour in
            }
        }
        .padding(.leading, 10)
    }
}
