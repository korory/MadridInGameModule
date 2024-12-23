//
//  DropdownMultipleSelectionCellComponentView.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 16/10/24.
//

import SwiftUI
import Combine

struct DropdownMultipleSelectionCellComponentView: View {
    @State var isSelected: Bool
    var title: String
    let optionSelected: (String, Bool) -> Void
    
    var body: some View {
        HStack (spacing: 20){
            toggleCheckboxComponent
            titleComponent
        }
        .padding()
    }
}

extension DropdownMultipleSelectionCellComponentView {
    private var toggleCheckboxComponent: some View {
        Toggle(isOn: $isSelected) {
        }
        .toggleStyle(iOSCheckboxToggleStyle())
        .onReceive(Just(isSelected)) { newCheckboxStatus in
        //.onChange(of: isSelected) { oldCheckboxStatus, newCheckboxStatus in
            optionSelected(title, newCheckboxStatus)
        }
    }
    
    private var titleComponent: some View {
        Text(title)
            .font(.body)
    }
}

struct iOSCheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }, label: {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                    .foregroundStyle(Color.cyan)
                configuration.label
            }
        })
    }
}

