//
//  DropdownCellComponentView.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 11/10/24.
//

import SwiftUI

struct DropdownCellComponentView: View {
    
    var cellModel: DropdownCellModel
    
    var body: some View {
        VStack {
            Image(systemName: cellModel.imageName) //TODO: Change this to real image
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundStyle(Color.white)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(Color.pink)
                        .frame(width: 80, height: 80)
                )
                .padding(.bottom, 20)
            
            Text(cellModel.title)
                .font(.body)
            
        }
        .padding()
    }
}

extension DropdownCellComponentView {
    
}
