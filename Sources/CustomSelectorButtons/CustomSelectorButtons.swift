//
//  CustomSelectorButtons.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 10/10/24.
//

import SwiftUI

struct CustomSelectorButtons: View {
    let items: [String]  // Horas o consolas
    @Binding var selectedItems: [String]  // Elementos seleccionados
    let pressEnabled: Bool
    let onSelect: (String) -> Void  // Acción al seleccionar un elemento

    var body: some View {
        VStack {
            ForEach(items, id: \.self) { item in
                CustomButton(text: item,
                             needsBackground: selectedItems.contains(item),
                             backgroundColor: selectedItems.contains(item) ? Color.white : Color.clear,
                             pressEnabled: pressEnabled,
                             widthButton: 180, heightButton: 50) {
                    print("Press \(item)")
                    onSelect(item)
                }
                             .padding(.bottom, 10)
            }
        }
        .padding(.bottom, 20)
    }
}

