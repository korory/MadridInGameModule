//
//  DropdownMultipleSelectionComponentView.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 16/10/24.
//

import SwiftUI

struct DropdownMultipleSelectionModel {
    var id = UUID()
    var title: String
    var isOptionSelected: Bool
}

struct DropdownMultipleSelectionComponentView: View {
    @State private var isExpanded: Bool = false
    @State var dropdownText: [String] = ["No hay ningún jugador seleccionado"]
    let options: [DropdownMultipleSelectionModel]
    let optionPressed: (String) -> Void
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    init(options: [DropdownMultipleSelectionModel], optionPressed: @escaping (String) -> Void) {
        self.options = options
        self.optionPressed = optionPressed
        self._dropdownText = State(initialValue: options.filter { $0.isOptionSelected }.map { $0.title })
    }
    
    var body: some View {
        DisclosureGroup(dropdownText.joined(separator: ", "), isExpanded: $isExpanded) {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(options, id: \.id) { option in
                    DropdownMultipleSelectionCellComponentView(isSelected: option.isOptionSelected, title: option.title) { textSelected, isOptionChecked in
                        if !dropdownText.contains(textSelected) {
                            dropdownText.append(textSelected)
                        } else {
                            dropdownText.removeAll { $0 == textSelected }
                        }
                        optionPressed(textSelected)
                    }
                }
            }
            .padding(.top, 20)
        }
        .foregroundStyle(Color.black)
        .padding()
        .background(Color.white)
        .cornerRadius(8)
    }
}

#Preview {
    DropdownMultipleSelectionComponentView(options: [
        DropdownMultipleSelectionModel(title: "Player 1", isOptionSelected: true),
        DropdownMultipleSelectionModel(title: "Player 2", isOptionSelected: true)
    ], optionPressed: { text in })
}

