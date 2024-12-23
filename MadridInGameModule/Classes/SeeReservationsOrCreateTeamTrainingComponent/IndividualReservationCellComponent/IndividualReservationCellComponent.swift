//
//  IndividualReservationCellComponent.swift
//  CalendarComponent
//
//  Created by Arnau Rivas Rivas on 15/10/24.
//

import SwiftUI

struct IndividualReservationCellComponent: View {
    @ObservedObject var viewModel: IndividualReservationCellComponentViewModel
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.7)
            VStack (alignment: .leading, spacing: 20){
                iconTextBannerComponent
                teamInformationComponent
                    .padding(.leading, 10)
            }
            .padding()
        }
        .clipShape(.rect(cornerRadius: 10))
    }
}

extension IndividualReservationCellComponent {
    private var iconTextBannerComponent: some View {
        HStack (spacing: 10) {
            Image(systemName: viewModel.trainingLocationImage)
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundStyle(Color.yellow)
            
            Text("ENTRENAMIENTO \(viewModel.getTrainingLocationText())")
                .font(.system(size: 18))
                .foregroundStyle(Color.white)
            
            Spacer()
        }
    }
    
    private var teamInformationComponent: some View {
        HStack {
            Image(uiImage: viewModel.teamAssigned.image)
                .resizable()
                .frame(width: 35, height: 35)
                .clipShape(Circle())
            
            Text(viewModel.teamAssigned.name)
                .font(.system(size: 15).weight(.bold))
                .foregroundStyle(Color.white.opacity(0.7))
            
            Text("\(viewModel.dateSelected) - \(viewModel.hourSelected)")
                .font(.system(size: 15))
                .foregroundStyle(Color.white.opacity(0.7))
        }
    }
}
