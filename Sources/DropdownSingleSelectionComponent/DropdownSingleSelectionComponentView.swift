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
    var textTop: String = ""
    let userInteraction: Bool
    let options: [DropdownSingleSelectionModel]
    
    var onOptionSelected: (DropdownSingleSelectionModel) -> Void
    
    init(options: [DropdownSingleSelectionModel], userInteraction: Bool = true, textTop: String, onOptionSelected: @escaping (DropdownSingleSelectionModel) -> Void) {
        self.options = options
        self.onOptionSelected = onOptionSelected
        self.textTop = textTop
        self.userInteraction = userInteraction
        
        if let selectedOption = options.first(where: { $0.isOptionSelected }) {
            self._dropdownText = State(initialValue: selectedOption.title)
            self._selectedOptionID = State(initialValue: selectedOption.id)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: -4) {
            Text(self.textTop)
                .font(.caption)
                .foregroundColor(.white)
                .background(Color.black)
                .padding(.leading, 10)
                .padding(.bottom, -6)
                .zIndex(1)
            
            DisclosureGroup(dropdownText, isExpanded: $isExpanded) {
                ForEach(options, id: \ .id) { option in
                    DropdownSingleSelectionCellComponent(isSelected: option.id == selectedOptionID, title: option.title) { selectedValueText in
                        self.dropdownText = selectedValueText
                        self.selectedOptionID = option.id
                        self.isExpanded = false
                        
                        if let selectedOption = options.first(where: { $0.id == selectedOptionID }) {
                            onOptionSelected(selectedOption)
                        }
                    }
                    .disabled(!userInteraction)
                    .padding(.vertical, 4)
                }
                .padding(.top, 8)
            }
            .foregroundStyle(Color.white)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white, lineWidth: 2)
                    .background(Color.clear)
            )
            .cornerRadius(16)
            .disabled(!userInteraction)
        }
        .padding(.leading, 5)
        .padding(.trailing, 5)
    }
}
