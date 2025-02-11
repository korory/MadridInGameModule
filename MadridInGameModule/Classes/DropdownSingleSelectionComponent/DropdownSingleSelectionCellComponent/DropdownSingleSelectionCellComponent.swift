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
        HStack (spacing: 20){
            checkImageAndTitleComponent
        }
        .padding()
    }
}

extension DropdownSingleSelectionCellComponent {
    
    private var checkImageAndTitleComponent: some View {
        HStack (spacing: 20){
            Image(systemName: isSelected ? "checkmark" : "")
                .resizable()
                .frame(width: 10, height: 10)
                .foregroundStyle(Color.cyan)
            
            Text(title)
                .font(.custom("Madridingamefont-Regular", size: 18))

                //.font(.body)
            
            Spacer()
        }
        .onTapGesture {
            optionSelected(title)
        }
    }
}
