//
//  DropdownSingleSelectionComponentView.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 16/10/24.
//

import SwiftUI

struct DropdownSingleSelectionModel {
    var id = UUID()
    var title: String
    var isOptionSelected: Bool
}

struct DropdownSingleSelectionComponentView: View {
    @State private var isExpanded: Bool = false
    @State var dropdownText: String = "Selecciona una opción"
    @State private var selectedOptionID: UUID? = nil
    let userInteraction: Bool
    let options: [DropdownSingleSelectionModel]
    
    var onOptionSelected: (DropdownSingleSelectionModel) -> Void
    
    init(options: [DropdownSingleSelectionModel], userInteraction: Bool = true, onOptionSelected: @escaping (DropdownSingleSelectionModel) -> Void) {
        self.options = options
        self.onOptionSelected = onOptionSelected
        self.userInteraction = userInteraction
        
        if let selectedOption = options.first(where: { $0.isOptionSelected }) {
            self._dropdownText = State(initialValue: selectedOption.title)
            self._selectedOptionID = State(initialValue: selectedOption.id)
        }
    }
    
    var body: some View {
        DisclosureGroup(dropdownText, isExpanded: $isExpanded) {
            ForEach(options, id: \.id) { option in
                DropdownSingleSelectionCellComponent(isSelected: option.id == selectedOptionID, title: option.title) { selectedValueText in
                    self.dropdownText = selectedValueText
                    self.selectedOptionID = option.id
                    self.isExpanded = false
                    
                    if let selectedOption = options.first(where: { $0.id == selectedOptionID }) {
                        onOptionSelected(selectedOption)
                    }
                }
                .disabled(!userInteraction)
                .padding(.vertical, 4) // Reduce el padding vertical de cada opción
            }
            .padding(.top, 8) // Menor separación de la lista
        }
        .foregroundStyle(Color.white)
        .padding(.horizontal, 12)
        .padding(.vertical, 6) // Compacta el padding general del componente
        .background(Color.gray.opacity(0.7)) // Fondo más sutil
        .cornerRadius(6)
        .disabled(!userInteraction)
    }
}


//struct DropdownSingleSelectionComponentView: View {
//    @State private var isExpanded: Bool = false
//    @State var dropdownText: String = "Selecciona una opción"
//    @State private var selectedOptionID: UUID? = nil
//    let userInteraction: Bool
//    let options: [DropdownSingleSelectionModel]
//    
//    // Closure que permite enviar la opción seleccionada al padre
//    var onOptionSelected: (DropdownSingleSelectionModel) -> Void
//    
//    init(options: [DropdownSingleSelectionModel], userInteraction: Bool = true, onOptionSelected: @escaping (DropdownSingleSelectionModel) -> Void) {
//        self.options = options
//        self.onOptionSelected = onOptionSelected
//        self.userInteraction = userInteraction
//        // Busca la opción seleccionada, si existe, asigna su título, de lo contrario, usa el texto por defecto
//        if let selectedOption = options.first(where: { $0.isOptionSelected }) {
//            self._dropdownText = State(initialValue: selectedOption.title)
//            self._selectedOptionID = State(initialValue: selectedOption.id)
//        }
//    }
//    
//    var body: some View {
//        DisclosureGroup(dropdownText, isExpanded: $isExpanded) {
//            ForEach(options, id: \.id) { option in
//                DropdownSingleSelectionCellComponent(isSelected: option.id == selectedOptionID, title: option.title) { selectedValueText in
//                    self.dropdownText = selectedValueText
//                    self.selectedOptionID = option.id
//                    self.isExpanded = false
//                    
//                    // Enviar la opción seleccionada al padre
//                    if let selectedOption = options.first(where: { $0.id == selectedOptionID }) {
//                        onOptionSelected(selectedOption)
//                    }
//                }
//                .disabled(!userInteraction)
//            }
//            .padding(.top, 20)
//        }
//        .foregroundStyle(Color.black)
//        .padding()
//        .background(Color.white)
//        .cornerRadius(8)
//        .disabled(!userInteraction)
//    }
//}
//
//#Preview {
//    DropdownSingleSelectionComponentView(options: [
//        DropdownSingleSelectionModel(title: "Player 1", isOptionSelected: true),
//        DropdownSingleSelectionModel(title: "Player 2", isOptionSelected: false)
//    ]) { selectedOption in
//        print("Opción seleccionada: \(selectedOption.title)")
//    }
//}
