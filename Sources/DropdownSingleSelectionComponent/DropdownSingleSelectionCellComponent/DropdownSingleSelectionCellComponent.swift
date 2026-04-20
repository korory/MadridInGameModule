//
//  DropdownSingleSelectionCellComponent.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 16/10/24.
//

import SwiftUI

struct DropdownSingleSelectionCellComponent: View {
    @State var isSelected: Bool
    var title: String
    let optionSelected: (String) -> Void
    
    var body: some View {
        HStack(spacing: 20) {
            checkImageAndTitleComponent
        }
        .padding()
        .contentShape(Rectangle()) // Hace que toda la celda sea interactuable
        .onTapGesture {
            optionSelected(title)
        }
    }
}

extension DropdownSingleSelectionCellComponent {
    
    private var checkImageAndTitleComponent: some View {
        HStack(spacing: 20) {
            Image(systemName: "checkmark")
                .resizable()
                .frame(width: 10, height: 10)
                .foregroundStyle(Color.cyan)
                .opacity(isSelected ? 1 : 0)
            
            Text(title)
                .font(.madridInGameiOSFont(size: 18))

            Spacer()
        }
    }
}
