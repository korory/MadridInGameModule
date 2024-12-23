//
//  DropdownComponentView.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 11/10/24.
//

import SwiftUI

struct DropdownComponentView: View {
    @State private var isExpanded: Bool = false
    var dropdownText: String = ""
    let options = ["Option 1", "Option 2", "Option 3", "Option 4", "Option 5", "Option 6"]
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        DisclosureGroup(dropdownText, isExpanded: $isExpanded) {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(options, id: \.self) { option in
                    DropdownCellComponentView(cellModel: DropdownCellModel(imageName: "exclamationmark.triangle", title: option))
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
    DropdownComponentView()
}
